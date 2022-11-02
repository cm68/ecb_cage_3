STLS= ecb3-left.stl ecb3-right.stl ecb3-top.stl ecb3-bottom.stl
all: $(STLS)

clobber: clean
	rm -f $(STLS)

clean:
	rm -f *.fpp

ecb3-left.stl:
	openscad -o ecb3-left.stl -D 'express="l"' ecb3-cage.scad

ecb3-right.stl:
	openscad -o ecb3-right.stl -D 'express="r"' ecb3-cage.scad

ecb3-top.stl:
	openscad -o ecb3-top.stl -D 'express="t"' ecb3-cage.scad

ecb3-bottom.stl:
	openscad -o ecb3-bottom.stl -D 'express="b"' ecb3-cage.scad

