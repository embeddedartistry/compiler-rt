project('compiler_rt',
	['c', 'cpp'],
	default_options : [
		# `build.*` options affect `native: true targets`
		# plain options affect `native: false` targets.
		'c_std=c11', 'build.c_std=c11',
		'cpp_std=c++17', 'build.cpp_std=c++17',
	],
	license: 'MIT',
	meson_version: '>0.51.0')

build_type = get_option('buildtype')

native_os = host_machine.system()
build_os = build_machine.system()

native_compiler = meson.get_compiler('cpp', native: true)
target_compiler = meson.get_compiler('cpp')

#########################
# Process Build Options #
#########################

enable_werror = get_option('enable-werror')
enable_pedantic_error = get_option('enable-pedantic-error')
force_32_bit = get_option('force-32-bit')
skip_atomic_builtins = get_option('compiler-rt-exclude-atomic-builtins')

#############################
# Initialize Compiler Flags #
#############################

subdir('meson/architecture')

message('Building compiler-rt for target architecture: ' + target_architecture)
message('Building compiler-rt for native architecture: ' + native_architecture)

builtins_compiler_args = [
	'-fno-builtin',
	'-fvisibility=hidden',
	'-fomit-frame-pointer',
	'-ffreestanding',
	# These are to suppress warnings when building compiler_rt with pedantic enabled
	'-Wno-pedantic',
	'-Wno-undef',
	'-Wno-sign-conversion',
	'-Wno-double-promotion',
	'-Wno-float-equal',
	'-Wno-float-conversion',
	'-Wno-conversion',
	'-Wno-missing-noreturn',
	'-Wno-unused-parameter',
	'-Wno-format-nonliteral',
	'-Wno-unused-macros',
]

builtins_target_compiler_args = [
	builtins_compiler_args,
]

builtins_native_compiler_args = [
	builtins_compiler_args,
]

if force_32_bit == true
	builtins_target_compiler_args += ['-m32']
	builtins_native_compiler_args += ['-m32']
endif

###################
# Adjust Warnings #
###################

if target_compiler.has_argument('-Wno-builtin-declaration-mismatch')
	builtins_target_compiler_args += '-Wno-builtin-declaration-mismatch'
endif

if native_compiler.has_argument('-Wno-builtin-declaration-mismatch')
	builtins_native_compiler_args += '-Wno-builtin-declaration-mismatch'
endif

if target_compiler.has_argument('-Wno-shift-sign-overflow')
	builtins_target_compiler_args += '-Wno-shift-sign-overflow'
endif

if native_compiler.has_argument('-Wno-shift-sign-overflow')
	builtins_native_compiler_args += '-Wno-shift-sign-overflow'
endif

if target_compiler.has_argument('-Wno-shorten-64-to-32')
	builtins_target_compiler_args += '-Wno-shorten-64-to-32'
endif

if native_compiler.has_argument('-Wno-shorten-64-to-32')
	builtins_native_compiler_args += '-Wno-shorten-64-to-32'
endif

if target_compiler.has_argument('-Wno-unreachable-code-break')
	builtins_target_compiler_args += '-Wno-unreachable-code-break'
endif

if native_compiler.has_argument('-Wno-unreachable-code-break')
	builtins_native_compiler_args += '-Wno-unreachable-code-break'
endif

if target_compiler.has_argument('-Wno-conditional-uninitialized')
	builtins_target_compiler_args += '-Wno-conditional-uninitialized'
endif

if native_compiler.has_argument('-Wno-conditional-uninitialized')
	builtins_native_compiler_args += '-Wno-conditional-uninitialized'
endif

if target_compiler.has_argument('-Wno-missing-variable-declarations')
	builtins_target_compiler_args += '-Wno-missing-variable-declarations'
endif

if native_compiler.has_argument('-Wno-missing-variable-declarations')
	builtins_native_compiler_args += '-Wno-missing-variable-declarations'
endif

if target_compiler.has_argument('-Wno-reserved-id-macro')
	builtins_target_compiler_args += '-Wno-reserved-id-macro'
endif

if native_compiler.has_argument('-Wno-reserved-id-macro')
	builtins_native_compiler_args += '-Wno-reserved-id-macro'
endif

if target_compiler.has_argument('-Wno-missing-prototypes') and target_compiler.get_id() != 'gcc'
	builtins_target_compiler_args += '-Wno-missing-prototypes'
endif

if native_compiler.has_argument('-Wno-missing-prototypes')  and native_compiler.get_id() != 'gcc'
	builtins_native_compiler_args += '-Wno-missing-prototypes'
endif

######################
# Builtin File Lists #
######################

generic_sources = files(
	'compiler-rt/lib/builtins/absvdi2.c',
	'compiler-rt/lib/builtins/absvsi2.c',
	'compiler-rt/lib/builtins/absvti2.c',
	'compiler-rt/lib/builtins/adddf3.c',
	'compiler-rt/lib/builtins/addsf3.c',
	'compiler-rt/lib/builtins/addtf3.c',
	'compiler-rt/lib/builtins/addvdi3.c',
	'compiler-rt/lib/builtins/addvsi3.c',
	'compiler-rt/lib/builtins/addvti3.c',
	'compiler-rt/lib/builtins/apple_versioning.c',
	'compiler-rt/lib/builtins/ashldi3.c',
	'compiler-rt/lib/builtins/ashlti3.c',
	'compiler-rt/lib/builtins/ashrdi3.c',
	'compiler-rt/lib/builtins/ashrti3.c',
	'compiler-rt/lib/builtins/clear_cache.c',
	'compiler-rt/lib/builtins/clzti2.c',
	'compiler-rt/lib/builtins/cmpdi2.c',
	'compiler-rt/lib/builtins/cmpti2.c',
	'compiler-rt/lib/builtins/comparedf2.c',
	'compiler-rt/lib/builtins/ctzdi2.c',
	'compiler-rt/lib/builtins/ctzsi2.c',
	'compiler-rt/lib/builtins/ctzti2.c',
	'compiler-rt/lib/builtins/divdc3.c',
	'compiler-rt/lib/builtins/divdf3.c',
	'compiler-rt/lib/builtins/divdi3.c',
	'compiler-rt/lib/builtins/divmoddi4.c',
	'compiler-rt/lib/builtins/divsc3.c',
	'compiler-rt/lib/builtins/divsf3.c',
	'compiler-rt/lib/builtins/divtc3.c',
	'compiler-rt/lib/builtins/divti3.c',
	'compiler-rt/lib/builtins/divtf3.c',
	'compiler-rt/lib/builtins/extendsfdf2.c',
	'compiler-rt/lib/builtins/extendhfsf2.c',
	'compiler-rt/lib/builtins/ffsdi2.c',
	'compiler-rt/lib/builtins/ffssi2.c',
	'compiler-rt/lib/builtins/ffsti2.c',
	'compiler-rt/lib/builtins/fixdfdi.c',
	'compiler-rt/lib/builtins/fixdfsi.c',
	'compiler-rt/lib/builtins/fixdfti.c',
	'compiler-rt/lib/builtins/fixsfdi.c',
	'compiler-rt/lib/builtins/fixsfsi.c',
	'compiler-rt/lib/builtins/fixsfti.c',
	'compiler-rt/lib/builtins/fixunsdfdi.c',
	'compiler-rt/lib/builtins/fixunsdfsi.c',
	'compiler-rt/lib/builtins/fixunsdfti.c',
	'compiler-rt/lib/builtins/fixunssfdi.c',
	'compiler-rt/lib/builtins/fixunssfsi.c',
	'compiler-rt/lib/builtins/fixunssfti.c',
	'compiler-rt/lib/builtins/floatsidf.c',
	'compiler-rt/lib/builtins/floatsisf.c',
	'compiler-rt/lib/builtins/floattidf.c',
	'compiler-rt/lib/builtins/floattisf.c',
	'compiler-rt/lib/builtins/floatunsidf.c',
	'compiler-rt/lib/builtins/floatunsisf.c',
	'compiler-rt/lib/builtins/floatuntidf.c',
	'compiler-rt/lib/builtins/floatuntisf.c',
	'compiler-rt/lib/builtins/int_util.c',
	'compiler-rt/lib/builtins/lshrdi3.c',
	'compiler-rt/lib/builtins/lshrti3.c',
	'compiler-rt/lib/builtins/moddi3.c',
	'compiler-rt/lib/builtins/modti3.c',
	'compiler-rt/lib/builtins/muldc3.c',
	'compiler-rt/lib/builtins/muldf3.c',
	'compiler-rt/lib/builtins/muldi3.c',
	'compiler-rt/lib/builtins/mulodi4.c',
	'compiler-rt/lib/builtins/mulosi4.c',
	'compiler-rt/lib/builtins/muloti4.c',
	'compiler-rt/lib/builtins/mulsc3.c',
	'compiler-rt/lib/builtins/mulsf3.c',
	'compiler-rt/lib/builtins/multi3.c',
	'compiler-rt/lib/builtins/multf3.c',
	'compiler-rt/lib/builtins/mulvdi3.c',
	'compiler-rt/lib/builtins/mulvsi3.c',
	'compiler-rt/lib/builtins/mulvti3.c',
	'compiler-rt/lib/builtins/negdf2.c',
	'compiler-rt/lib/builtins/negdi2.c',
	'compiler-rt/lib/builtins/negsf2.c',
	'compiler-rt/lib/builtins/negti2.c',
	'compiler-rt/lib/builtins/negvdi2.c',
	'compiler-rt/lib/builtins/negvsi2.c',
	'compiler-rt/lib/builtins/negvti2.c',
	# This file is used by Obj-C and won't build without clang
	#'compiler-rt/lib/builtins/os_version_check.c',
	'compiler-rt/lib/builtins/paritydi2.c',
	'compiler-rt/lib/builtins/paritysi2.c',
	'compiler-rt/lib/builtins/parityti2.c',
	'compiler-rt/lib/builtins/popcountdi2.c',
	'compiler-rt/lib/builtins/popcountsi2.c',
	'compiler-rt/lib/builtins/popcountti2.c',
	'compiler-rt/lib/builtins/powidf2.c',
	'compiler-rt/lib/builtins/powisf2.c',
	'compiler-rt/lib/builtins/powitf2.c',
	'compiler-rt/lib/builtins/subdf3.c',
	'compiler-rt/lib/builtins/subsf3.c',
	'compiler-rt/lib/builtins/subvdi3.c',
	'compiler-rt/lib/builtins/subvsi3.c',
	'compiler-rt/lib/builtins/subvti3.c',
	'compiler-rt/lib/builtins/subtf3.c',
	'compiler-rt/lib/builtins/trampoline_setup.c',
	'compiler-rt/lib/builtins/truncdfhf2.c',
	'compiler-rt/lib/builtins/truncdfsf2.c',
	'compiler-rt/lib/builtins/truncsfhf2.c',
	'compiler-rt/lib/builtins/ucmpdi2.c',
	'compiler-rt/lib/builtins/ucmpti2.c',
	'compiler-rt/lib/builtins/udivdi3.c',
	'compiler-rt/lib/builtins/udivmoddi4.c',
	'compiler-rt/lib/builtins/udivmodti4.c',
	'compiler-rt/lib/builtins/udivti3.c',
	'compiler-rt/lib/builtins/umoddi3.c',
	'compiler-rt/lib/builtins/umodti3.c',
)

generic_nonarm_sources = files(
	'compiler-rt/lib/builtins/bswapdi2.c',
	'compiler-rt/lib/builtins/bswapsi2.c',
	'compiler-rt/lib/builtins/clzdi2.c',
	'compiler-rt/lib/builtins/clzsi2.c',
	'compiler-rt/lib/builtins/comparesf2.c',
	'compiler-rt/lib/builtins/divmodsi4.c',
	'compiler-rt/lib/builtins/divsi3.c',
	'compiler-rt/lib/builtins/modsi3.c',
	'compiler-rt/lib/builtins/udivmodsi4.c',
	'compiler-rt/lib/builtins/udivsi3.c',
	'compiler-rt/lib/builtins/umodsi3.c',
)

generic_nonx86_64_sources = files(
	'compiler-rt/lib/builtins/floatdidf.c',
	'compiler-rt/lib/builtins/floatdisf.c',
	'compiler-rt/lib/builtins/floatundidf.c',
	'compiler-rt/lib/builtins/floatundisf.c',
)

generic_tf_sources = files(
	'compiler-rt/lib/builtins/comparetf2.c',
	'compiler-rt/lib/builtins/extenddftf2.c',
	'compiler-rt/lib/builtins/extendsftf2.c',
	'compiler-rt/lib/builtins/fixtfdi.c',
	'compiler-rt/lib/builtins/fixtfsi.c',
	'compiler-rt/lib/builtins/fixtfti.c',
	'compiler-rt/lib/builtins/fixunstfdi.c',
	'compiler-rt/lib/builtins/fixunstfsi.c',
	'compiler-rt/lib/builtins/fixunstfti.c',
	'compiler-rt/lib/builtins/floatditf.c',
	'compiler-rt/lib/builtins/floatsitf.c',
	'compiler-rt/lib/builtins/floattitf.c',
	'compiler-rt/lib/builtins/floatunditf.c',
	'compiler-rt/lib/builtins/floatunsitf.c',
	'compiler-rt/lib/builtins/floatuntitf.c',
	'compiler-rt/lib/builtins/multc3.c',
	'compiler-rt/lib/builtins/trunctfdf2.c',
	'compiler-rt/lib/builtins/trunctfsf2.c',
)

nonbaremetal_files = files(
	'compiler-rt/lib/builtins/emutls.c',
	'compiler-rt/lib/builtins/enable_execute_stack.c',
	'compiler-rt/lib/builtins/eprintf.c',
)

x86_files = files(
	'compiler-rt/lib/builtins/cpu_model.c',
	'compiler-rt/lib/builtins/divxc3.c',
	'compiler-rt/lib/builtins/fixxfdi.c',
	'compiler-rt/lib/builtins/fixxfti.c',
	'compiler-rt/lib/builtins/fixunsxfdi.c',
	'compiler-rt/lib/builtins/fixunsxfsi.c',
	'compiler-rt/lib/builtins/fixunsxfti.c',
	'compiler-rt/lib/builtins/floatdixf.c',
	'compiler-rt/lib/builtins/floattixf.c',
	'compiler-rt/lib/builtins/floatundixf.c',
	'compiler-rt/lib/builtins/floatuntixf.c',
	'compiler-rt/lib/builtins/mulxc3.c',
	'compiler-rt/lib/builtins/powixf2.c',
)

x86_64_files = files(
	'compiler-rt/lib/builtins/x86_64/floatdidf.c',
	'compiler-rt/lib/builtins/x86_64/floatdisf.c',
	'compiler-rt/lib/builtins/x86_64/floatdixf.c',
	'compiler-rt/lib/builtins/x86_64/floatundidf.S',
	'compiler-rt/lib/builtins/x86_64/floatundisf.S',
	'compiler-rt/lib/builtins/x86_64/floatundixf.S',
)

arm_files = files(
	'compiler-rt/lib/builtins/arm/fp_mode.c',
	'compiler-rt/lib/builtins/arm/bswapdi2.S',
	'compiler-rt/lib/builtins/arm/bswapsi2.S',
	'compiler-rt/lib/builtins/arm/clzdi2.S',
	'compiler-rt/lib/builtins/arm/clzsi2.S',
	'compiler-rt/lib/builtins/arm/comparesf2.S',
	'compiler-rt/lib/builtins/arm/divmodsi4.S',
	'compiler-rt/lib/builtins/arm/divsi3.S',
	'compiler-rt/lib/builtins/arm/modsi3.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_add_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_add_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_and_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_and_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_max_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_max_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_min_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_min_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_nand_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_nand_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_or_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_or_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_sub_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_sub_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_umax_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_umax_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_umin_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_umin_8.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_xor_4.S',
	'compiler-rt/lib/builtins/arm/sync_fetch_and_xor_8.S',
	'compiler-rt/lib/builtins/arm/udivmodsi4.S',
	'compiler-rt/lib/builtins/arm/udivsi3.S',
	'compiler-rt/lib/builtins/arm/umodsi3.S',
)

arm_thumb1_files = files(
	'compiler-rt/lib/builtins/arm/addsf3.S',
	'compiler-rt/lib/builtins/arm/divsi3.S',
	'compiler-rt/lib/builtins/arm/udivsi3.S',
	'compiler-rt/lib/builtins/arm/comparesf2.S',
	# Thumb1_JT
	'compiler-rt/lib/builtins/arm/switch16.S',
	'compiler-rt/lib/builtins/arm/switch32.S',
	'compiler-rt/lib/builtins/arm/switch8.S',
	'compiler-rt/lib/builtins/arm/switchu8.S',
	# Thumb1 ICache Sources
	'compiler-rt/lib/builtins/arm/sync_synchronize.S',
)

arm_vfp2_common_files = files(
	# SjLj EH Sources
	'compiler-rt/lib/builtins/arm/restore_vfp_d8_d15_regs.S',
	'compiler-rt/lib/builtins/arm/save_vfp_d8_d15_regs.S',
	# Thumb1_VFPv2_sources
	'compiler-rt/lib/builtins/arm/addsf3vfp.S',
	'compiler-rt/lib/builtins/arm/divsf3vfp.S',
	'compiler-rt/lib/builtins/arm/eqdf2vfp.S',
	'compiler-rt/lib/builtins/arm/eqsf2vfp.S',
	'compiler-rt/lib/builtins/arm/fixsfsivfp.S',
	'compiler-rt/lib/builtins/arm/fixunssfsivfp.S',
	'compiler-rt/lib/builtins/arm/floatsisfvfp.S',
	'compiler-rt/lib/builtins/arm/floatunssisfvfp.S',
	'compiler-rt/lib/builtins/arm/gedf2vfp.S',
	'compiler-rt/lib/builtins/arm/gesf2vfp.S',
	'compiler-rt/lib/builtins/arm/gtdf2vfp.S',
	'compiler-rt/lib/builtins/arm/gtsf2vfp.S',
	'compiler-rt/lib/builtins/arm/ledf2vfp.S',
	'compiler-rt/lib/builtins/arm/lesf2vfp.S',
	'compiler-rt/lib/builtins/arm/ltdf2vfp.S',
	'compiler-rt/lib/builtins/arm/ltsf2vfp.S',
	'compiler-rt/lib/builtins/arm/mulsf3vfp.S',
	'compiler-rt/lib/builtins/arm/nedf2vfp.S',
	'compiler-rt/lib/builtins/arm/negdf2vfp.S',
	'compiler-rt/lib/builtins/arm/negsf2vfp.S',
	'compiler-rt/lib/builtins/arm/nesf2vfp.S',
	'compiler-rt/lib/builtins/arm/subsf3vfp.S',
	'compiler-rt/lib/builtins/arm/unorddf2vfp.S',
	'compiler-rt/lib/builtins/arm/unordsf2vfp.S',
)

arm_vfp_double_precision_files = files(
	'compiler-rt/lib/builtins/arm/adddf3vfp.S',
	'compiler-rt/lib/builtins/arm/divdf3vfp.S',
	'compiler-rt/lib/builtins/arm/extendsfdf2vfp.S',
	'compiler-rt/lib/builtins/arm/fixdfsivfp.S',
	'compiler-rt/lib/builtins/arm/fixunsdfsivfp.S',
	'compiler-rt/lib/builtins/arm/floatunssidfvfp.S',
	'compiler-rt/lib/builtins/arm/floatsidfvfp.S',
	'compiler-rt/lib/builtins/arm/muldf3vfp.S',
	'compiler-rt/lib/builtins/arm/subdf3vfp.S',
	'compiler-rt/lib/builtins/arm/truncdfsf2vfp.S',
)

arm_eabi_files = files(
	'compiler-rt/lib/builtins/arm/aeabi_cdcmp.S',
	'compiler-rt/lib/builtins/arm/aeabi_cdcmpeq_check_nan.c',
	'compiler-rt/lib/builtins/arm/aeabi_cfcmp.S',
	'compiler-rt/lib/builtins/arm/aeabi_cfcmpeq_check_nan.c',
	'compiler-rt/lib/builtins/arm/aeabi_dcmp.S',
	'compiler-rt/lib/builtins/arm/aeabi_div0.c',
	'compiler-rt/lib/builtins/arm/aeabi_drsub.c',
	'compiler-rt/lib/builtins/arm/aeabi_fcmp.S',
	'compiler-rt/lib/builtins/arm/aeabi_frsub.c',
	'compiler-rt/lib/builtins/arm/aeabi_idivmod.S',
	'compiler-rt/lib/builtins/arm/aeabi_ldivmod.S',
	'compiler-rt/lib/builtins/arm/aeabi_memcmp.S',
	'compiler-rt/lib/builtins/arm/aeabi_memcpy.S',
	'compiler-rt/lib/builtins/arm/aeabi_memmove.S',
	'compiler-rt/lib/builtins/arm/aeabi_memset.S',
	'compiler-rt/lib/builtins/arm/aeabi_uidivmod.S',
	'compiler-rt/lib/builtins/arm/aeabi_uldivmod.S',
)

arm_file_group = [
	arm_files,
	arm_eabi_files,
	arm_thumb1_files,
]

thumb1_file_group = [
	arm_eabi_files,
	arm_thumb1_files,
]

atomic_files = files(
	'compiler-rt/lib/builtins/atomic.c'
)

apple_atomic_files = files(
	'compiler-rt/lib/builtins/atomic_flag_clear.c',
	'compiler-rt/lib/builtins/atomic_flag_clear_explicit.c',
	'compiler-rt/lib/builtins/atomic_flag_test_and_set.c',
	'compiler-rt/lib/builtins/atomic_flag_test_and_set_explicit.c',
	'compiler-rt/lib/builtins/atomic_signal_fence.c',
	'compiler-rt/lib/builtins/atomic_thread_fence.c',
)

gcc_unwind_files = files(
	'compiler-rt/lib/builtins/gcc_personality_v0.c',
)

compiler_rt_target_files = [
	generic_sources,
]

compiler_rt_native_files = [
	generic_sources,
]

################################
# Select Files by Architecture #
################################

if meson.is_cross_build() == true
	# Build target for baremetal, exclude nonbaremetal files
	compiler_rt_native_files += nonbaremetal_files

	if build_machine.system() == 'darwin' and target_compiler.get_id() != 'gcc'
		compiler_rt_native_files += apple_atomic_files
	endif
else
	compiler_rt_native_files += nonbaremetal_files
	compiler_rt_target_files += nonbaremetal_files

	if host_machine.system() == 'darwin' and target_compiler.get_id() != 'gcc'
		compiler_rt_native_files += apple_atomic_files
		compiler_rt_target_files += apple_atomic_files
	endif
endif

if not skip_atomic_builtins
	compiler_rt_target_files += atomic_files
	compiler_rt_native_files += atomic_files
endif

if target_architecture == 'arm'
	compiler_rt_target_files += [
		arm_file_group,
		generic_nonx86_64_sources
	]

	arm_fp_setting = target_compiler.get_define('__ARM_FP')
	arm_version = target_compiler.get_define('__ARM_ARCH')

	# Single precision (aka 32 bit support) is true when bit 2 is set (0bx1xx)
	if arm_fp_setting == '4' or arm_fp_setting == '12' or arm_fp_setting == '14'
		message('Enabling single-precision ARM VFP Builtins')
		if(arm_version.to_int() < 7)
			# VFPv2 files are only needed for ARMv5 and ARMv6
			compiler_rt_target_files += arm_vfp2_common_files
		endif
	endif

	# Double precision (aka 64 bit support) is true when bit 3 is set (0b1xxx)
	if arm_fp_setting == '8' or arm_fp_setting == '12' or arm_fp_setting == '14'
		message('Enabling double-precision ARM VFP Builtins')
		compiler_rt_target_files + arm_vfp_double_precision_files
	endif

elif target_architecture == 'aarch64' or target_architecture == 'arm64'
	compiler_rt_target_files += [
		generic_tf_sources,
		generic_nonx86_64_sources,
		generic_nonarm_sources
	]
elif target_architecture == 'x86'
	compiler_rt_target_files += [
		x86_files,
		generic_nonx86_64_sources,
		generic_nonarm_sources
	]
elif target_architecture == 'x86_64'
	compiler_rt_target_files += [
		x86_files,
		x86_64_files,
		generic_nonarm_sources
	]
else
	assert(0, 'Unsupported architecture: ' + target_architecture)
endif

if native_architecture == 'arm'
	compiler_rt_native_files += [
		arm_files,
		generic_nonx86_64_sources
	]

	arm_fp_setting = native_compiler.get_define('__ARM_FP')
	arm_version = native_compiler.get_define('__ARM_ARCH')

	# Single precision (aka 32 bit support) is true when bit 2 is set (0bx1xx)
	if arm_fp_setting == '4' or arm_fp_setting == '12' or arm_fp_setting == '14'
		message('Enabling single-precision ARM VFP Builtins')
		if(arm_version.to_int() < 7)
			compiler_rt_native_files += arm_vfp2_common_files
		endif
	endif

	# Double precision (aka 64 bit support) is true when bit 3 is set (0b1xxx)
	if arm_fp_setting == '8' or arm_fp_setting == '12' or arm_fp_setting == '14'
		message('Enabling double-precision ARM VFP Builtins')
		compiler_rt_native_files + arm_vfp_double_precision_files
	endif

elif native_architecture == 'aarch64' or native_architecture == 'arm64'
	compiler_rt_native_files += [
		generic_tf_sources,
		generic_nonx86_64_sources,
		generic_nonarm_sources
	]
elif native_architecture == 'x86'
	compiler_rt_native_files += [
		x86_files,
		generic_nonx86_64_sources,
		generic_nonarm_sources
	]
elif native_architecture == 'x86_64'
	compiler_rt_native_files += [
		x86_files,
		x86_64_files,
		generic_nonarm_sources
	]
else
	assert(0, 'Unsupported architecture: ' + native_architecture)
endif

#########################
# Library Build Targets #
#########################

compiler_rt_builtins = static_library('compiler_rt',
	compiler_rt_target_files,
	c_args: builtins_target_compiler_args,
	cpp_args: builtins_target_compiler_args,
	pic: true,
)

compiler_rt_native_builtins = static_library('compiler_rt_native',
	compiler_rt_native_files,
	c_args: builtins_native_compiler_args,
	cpp_args: builtins_native_compiler_args,
	pic: true,
	native: true
)

compiler_rt_builtins_dep = declare_dependency(
	link_with: compiler_rt_builtins
)

compiler_rt_builtins_native_dep = declare_dependency(
	link_with: compiler_rt_native_builtins
)
