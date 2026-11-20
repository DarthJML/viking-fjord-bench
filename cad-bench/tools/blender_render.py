# Headless CPU preview render for the CAD bench (Blender >= 3.x, run with -b -P).
# Usage: blender.exe -b -P blender_render.py -- stl=file.stl outdir=.
import bpy
import os
import sys
from mathutils import Vector


def argv_after_dashdash():
    if "--" in sys.argv:
        return sys.argv[sys.argv.index("--") + 1:]
    return []


def arg(name, default):
    for a in argv_after_dashdash():
        if a.startswith(name + "="):
            return a.split("=", 1)[1]
    return default


_here = os.path.dirname(os.path.abspath(__file__))
stl = arg("stl", os.path.join(_here, "viking-shield-phone-stand.stl"))
outdir = arg("outdir", _here)

bpy.ops.wm.read_factory_settings(use_empty=True)

try:
    bpy.ops.wm.stl_import(filepath=stl)
except AttributeError:
    bpy.ops.import_mesh.stl(filepath=stl)

obj = bpy.context.selected_objects[0]
print("imported:", obj.name)

# bbox center (STL is mm, z-up, matching OpenSCAD export)
bb = [obj.matrix_world @ Vector(c) for c in obj.bound_box]
cx = sum(v.x for v in bb) / 8.0
cy = sum(v.y for v in bb) / 8.0
cz = sum(v.z for v in bb) / 8.0
target = Vector((cx, cy, cz))
print("bbox center:", tuple(round(c, 1) for c in target))

# --- world: dark backdrop to match the bench page ---
world = bpy.data.worlds.new("bench_world")
world.use_nodes = True
bg = world.node_tree.nodes["Background"]
bg.inputs[0].default_value = (0.035, 0.04, 0.055, 1.0)
bg.inputs[1].default_value = 1.0
bpy.context.scene.world = world

# --- material: warm bronze PLA-ish ---
mat = bpy.data.materials.new("pla_bronze")
mat.use_nodes = True
bsdf = mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = (0.52, 0.36, 0.17, 1.0)
bsdf.inputs["Metallic"].default_value = 0.15
bsdf.inputs["Roughness"].default_value = 0.45
obj.data.materials.append(mat)


def look_at(ob, tgt):
    d = Vector(tgt) - ob.location
    ob.rotation_euler = d.to_track_quat("-Z", "Y").to_euler()


# --- lights ---
sun_data = bpy.data.lights.new("sun", "SUN")
sun_data.energy = 4.0
sun = bpy.data.objects.new("sun", sun_data)
bpy.context.scene.collection.objects.link(sun)
sun.location = (180.0, 160.0, 260.0)
look_at(sun, target)

fill_data = bpy.data.lights.new("fill", "AREA")
fill_data.size = 90.0
fill_data.energy = 900.0
fill = bpy.data.objects.new("fill", fill_data)
bpy.context.scene.collection.objects.link(fill)
fill.location = (-220.0, 150.0, 60.0)
look_at(fill, target)

rim_data = bpy.data.lights.new("rimlight", "AREA")
rim_data.size = 70.0
rim_data.energy = 600.0
rim = bpy.data.objects.new("rimlight", rim_data)
bpy.context.scene.collection.objects.link(rim)
rim.location = (-60.0, -260.0, 140.0)
look_at(rim, target)

# --- camera ---
cam_data = bpy.data.cameras.new("cam")
cam_data.lens = 50
cam = bpy.data.objects.new("cam", cam_data)
bpy.context.scene.collection.objects.link(cam)
bpy.context.scene.camera = cam

# views: eye position + per-view key-light position
# front = phone/user side (+y), back = boss/rim side (-y), side = +x
views = {
    "front": (Vector((150.0, 235.0, 105.0)), Vector((180.0, 160.0, 260.0))),
    "back":  (Vector((-165.0, -215.0, 95.0)),  Vector((-40.0, -300.0, 220.0))),
    "side":  (Vector((255.0, -35.0, 60.0)),    Vector((280.0, 60.0, 200.0))),
}

scn = bpy.context.scene
scn.render.engine = "CYCLES"
scn.cycles.device = "CPU"          # HARD RULE: no GPU
scn.render.threads_mode = "FIXED"
scn.render.threads = 6
scn.cycles.samples = 40
scn.render.resolution_x = 960
scn.render.resolution_y = 720
scn.render.image_settings.file_format = "PNG"

for name, (eye, sun_pos) in views.items():
    sun.location = sun_pos
    look_at(sun, target)
    cam.location = eye
    look_at(cam, target)
    scn.render.filepath = f"{outdir}/preview-{name}.png"
    bpy.ops.render.render(write_still=True)
    print("wrote", scn.render.filepath)

print("done")
