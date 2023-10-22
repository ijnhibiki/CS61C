from distutils.core import setup, Extension
import sysconfig

def main():
    CFLAGS = ['-g', '-Wall', '-Wno-unused-function', '-Wconversion', '-std=c99', '-fopenmp', '-mavx', '-mfma', '-pthread', '-O3']
    LDFLAGS = ['-fopenmp']

    numc_module = Extension("numc",
                            sources=["src/numc.c", "src/matrix.c"],
                            extra_compile_args=CFLAGS,
                            extra_link_args=LDFLAGS,
                            language='c')

    dumbpy_module = Extension("dumbpy",
                              sources=["src/dumbpy.c", "src/dumbpy_matrix.c"],
                              extra_compile_args=CFLAGS,
                              extra_link_args=LDFLAGS,
                              language='c')

    setup(name="MyPackages",
          version="0.0.1",
          description="Numc and Dumbpy matrix operations",
          ext_modules=[numc_module, dumbpy_module])

if __name__ == "__main__":
    main()
