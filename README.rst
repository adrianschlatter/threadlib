.. image:: docs/imgs/logo.png
        :alt: bolt-in-nut logo

threadlib is a library of standard threads for `OpenSCAD <https://www.openscad.org>`__.
It is based on Helges excellent
`threadprofile.scad <https://github.com/MisterHW/IoP-satellite/tree/master/OpenSCAD%20bottle%20threads>`__
to create nice threads with lead-in / lead-out tapers. Check out his `article on generating nice threads <https://hackaday.io/page/5252-generating-nice-threads-in-openscad>`__
on Hackaday.

In contrast to other thread libraries such as `openscad-threads <http://dkprojects.net/openscad-threads/>`__,
`yet another thread library <https://www.thingiverse.com/thing:2277141>`__,
`threads for screws and nuts V1 <https://www.thingiverse.com/thing:3131126>`__,
and `threading.scad <https://www.thingiverse.com/thing:1659079>`__,
threadlib does not make you look up diameters and pitches and maybe even
thread-profiles in tables and norms: It has these tables built in.

Creating a thread is as simple as

.. code-block:: OpenSCAD

        use <threadlib/threadlib.scad>
        thread("G1/2-ext", turns=10);

.. image:: docs/imgs/thread-G1o2-ext-10turns.png
        :alt: bolt-in-nut logo

to create a British Standard Pipe parallel external thread. 
G1/2 is the name of the thread type, metrical would be e.g. M4, -ext or -int specifies if you want the external version of the thread, or the internal, CAREFUL to omit those specifiers when using the nut or bolt module!


Why you may want to use threadlib
==================================

- really easy to use
- creates nice threads
- configurable higbee arc
- creates working threads (clearances are left for production tolerances)
- flexible:

  - choose the $fn you need to fit the rest of your design
  - let threadlib tell you the thread specs so you can do with them what *you* want
- extensible: Add your own threads
- tried and tested in the real world: Well, partly. Given the sheer number of
  threads, this is only possible with *your* help! Any feedback regarding working
  (or not working) threadlib-threads is appreciated.


Installation
===========================

Prerequisits:

- `scad-utils <https://github.com/openscad/scad-utils>`__
- `list-comprehension <https://github.com/openscad/list-comprehension-demos>`__
- `threadprofile.scad <https://github.com/MisterHW/IoP-satellite/blob/master/OpenSCAD%20bottle%20threads/thread_profile.scad>`__
  
Save all of these into your OpenSCAD `library folder <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries>`__

threadlib:

Clone threadlib into the folder 'threadlib' inside your OpenSCAD library folder


Usage
===========================

Before you start: threadlib is designed in millimeters (not meters, not inches).
Make sure that your units are set accordingly or scale the output of threadlib
to match the units you use in your project!

To create a bolt (without head) with 5 turns of M4 thread:

.. code-block:: OpenSCAD

        bolt("M4", turns=5, higbee_arc=30);

.. image:: docs/imgs/bolt-M4.png
        :alt: Bolt with M4 thread

See these nice lead-in / lead-out tapers? Try a nut (this time using the default
argument for higbee_arc):

.. code-block:: OpenSCAD

        nut("M12x0.5", turns=10, Douter=16);

.. image:: docs/imgs/nut-M12x0.5.png
        :alt: M12x0.5 nut

Note that for a nut you also have to specify an outer diameter. The inner
diameter is implicitly given by the thread designator ("M12x0.5" in this case).

If you only need the threads alone:

.. code-block:: OpenSCAD

        thread("G1/2-ext", turns=5);

.. image:: docs/imgs/thread-G1o2-ext.png
        :alt: G1/2 external thread
 
Then, add the support you want. In the simplest case, a cylinder (which is what
nut(...) uses):

.. code-block:: OpenSCAD

        specs = thread_specs("G2 1/2-ext");
        P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
        section_profile = specs[3];
        H = (5 + 1) * P;
        translate([0, 0, -P / 2])
            cylinder(h=H, d=Dsupport, $fn=120);

.. image:: docs/imgs/flexible.png
        :alt: G1/2 bolt

Here, we have used the function thread_specs(...) to look up the threads
specifications - including the recommended diameter of the support structure.


List of supported threads
===========================

Currently, threadlib knows these threads:

- `Metric threads <http://mdmetric.com/tech/M-thead%20600.htm>`__ (coarse, fine, and super-fine pitches) M0.25 to M600
- `BSP parallel thread <https://www.amesweb.info/Screws/British-Standard-Pipe-Parallel-Thread-BSPP.aspx>`__ G1/16 to G6
- `PCO-1881 <https://www.bevtech.org/assets/Committees/Packaging-Technology/20/3784253-20.pdf>`__ (PET-bottle thread)


Extensibility
===========================

Don't find some of the threads you need for your project? Don't worry: You can
add your own:

.. code-block:: OpenSCAD

        use <threadlib/threadlib.scad>

        MY_THREAD_TABLE = [
                           ["special", [pitch, Rrot, Dsupport,
                           [[r0, z0], [r1, z1], ..., [rn, zn]]]]
                           ];

        thread("special", turns=15, table=MY_THREAD_TABLE);

Care to share? Safe others from repeating the valuable work you have already
accomplished and get the fame you deserve: Send in your tried and tested threads
for addition to threadlib!


Change Log
===========================

- 0.3: Unified Inch Screw Threads (UNC, UNF, UNEF, 4-UN, 6-UN, 8-UN, 12-UN,
  16-UN, 20-UN, 28-UN, and 32-UN. Fixed problem with PCO-1881-int. Fixed problem
  with G-ext threads . New build system. 
- 0.2: `Metric threads <http://mdmetric.com/tech/M-thead%20600.htm>`__, `PCO-1881 <https://www.bevtech.org/assets/Committees/Packaging-Technology/20/3784253-20.pdf>`__
- 0.1: Initial release supporting `BSP parallel thread <https://www.amesweb.info/Screws/British-Standard-Pipe-Parallel-Thread-BSPP.aspx>`__

