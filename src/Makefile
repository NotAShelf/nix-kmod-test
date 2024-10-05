# «https://docs.kernel.org/kbuild/modules.html»
KERNELRELEASE ?= $(shell uname -r)
KERNELDIR ?= /lib/modules/$(KERNELRELEASE)/build/

.PHONY: default
default: modules

# -m: Build as module.
obj-m += test.o

.PHONY: modules
modules:
	@#"M=": Module source.
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

.PHONY: modules_install
modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

.PHONY: clean
clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean

.PHONY: help
help:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) help
