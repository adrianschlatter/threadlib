os = /usr/local/bin/openscad
opts =
imgs = bolt-M4.png nut-M12x0.5.png nutNbolt.png thread-G1o2-ext.png thread-G1o2-ext-10turns.png flexible.png tap.png

.PHONY: all
all: $(imgs)

bolt-M4.png: bolt.scad
	$(os) $(opts) --D 'type="M4"' --D 'turns=5' --D 'higbee_arc=30' --camera=0.49,-0.26,1.55,74.6,0.0,78.9,20 --imgsize=2048,2048 -o $@ $<

nut-M12x0.5.png: nut.scad
	$(os) $(opts) --D 'type="M12x0.5"' --D 'turns=10' --D 'higbee_arc=20' --D 'Douter=16' --camera=-2.2,1.2,1.8,66,0,73,52 --imgsize=2048,2048 --projection=ortho -o $@ $<

nutNbolt.png: nutNbolt.scad
	$(os) $(opts) --camera=-0.24,1.19,4.24,83,0,326.9,40.3 --imgsize=2048,2048 --projection=ortho -o $@ $<

thread-G1o2-ext-10turns.png: thread.scad
	$(os) $(opts) --D 'type="G1/2-ext"' --D 'turns=10' --D 'higbee_arc=20' --camera=-0.7,-0.6,3.4,75,0,110,100 --imgsize=2048,2048 --projection=ortho -o $@ $<

thread-G1o2-ext.png: thread.scad
	$(os) $(opts) --D 'type="G1/2-ext"' --D 'turns=5' --D 'higbee_arc=20' --camera=-0.7,-0.6,3.4,75,0,110,57 --imgsize=2048,2048 --projection=ortho -o $@ $<

flexible.png: flexible.scad
	$(os) $(opts) --D 'type="G1/2-ext"' --D 'turns=5' --D 'higbee_arc=20' --camera=-0.7,-0.6,3.4,75,0,110,57 --imgsize=2048,2048 --projection=ortho -o $@ $<

tap.png: tap.scad
	$(os) $(opts) --D 'type="G1/2"' --D 'turns=5' --D 'higbee_arc=20' --camera=7,15.3,3.45,87,0,333,65 --imgsize=2048,2048 --projection=ortho -o $@ $<


.PHONY: clean
clean:
	rm *.png
