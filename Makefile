.PHONY: design
design: clean
	touch design/THREAD_TABLE.csv
	cat design/BSPP_thread.csv | awk -f design/BSPP_thread.awk >> design/THREAD_TABLE.csv
	cat design/metric_thread.csv | awk -f design/metric_thread.awk >> design/THREAD_TABLE.csv
	cat design/PCO_thread.csv | awk -f design/PCO_thread.awk >> design/THREAD_TABLE.csv
	cat design/UIS_thread.csv | awk -f design/UIS_thread.awk >> design/THREAD_TABLE.csv
	cat design/microscope_thread.csv | awk -f design/microscope_thread.awk >> design/THREAD_TABLE.csv
	cat design/THREAD_TABLE.csv | awk -f design/autogenerate.awk > THREAD_TABLE.scad

.PHONY: test
test:
	@$(MAKE) -C tests

.PHONY: clean
clean:
	rm -f THREAD_TABLE.scad
	rm -f design/THREAD_TABLE.csv
	rm -f docs/img_prep/*.png

.PHONY: img_prep
img_prep:
	@$(MAKE) -C docs/img_prep
