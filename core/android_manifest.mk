# Handle AndroidManifest.xmls
# Input: LOCAL_MANIFEST_FILE, LOCAL_FULL_MANIFEST_FILE, LOCAL_FULL_LIBS_MANIFEST_FILES
# Output: full_android_manifest

ifeq ($(strip $(LOCAL_MANIFEST_FILE)),)
  LOCAL_MANIFEST_FILE := AndroidManifest.xml
endif
ifdef LOCAL_FULL_MANIFEST_FILE
  full_android_manifest := $(LOCAL_FULL_MANIFEST_FILE)
else
  full_android_manifest := $(LOCAL_PATH)/$(LOCAL_MANIFEST_FILE)
endif

LOCAL_STATIC_JAVA_AAR_LIBRARIES := $(strip $(LOCAL_STATIC_JAVA_AAR_LIBRARIES))

my_full_libs_manifest_files :=

ifndef LOCAL_DONT_MERGE_MANIFESTS
  my_full_libs_manifest_files += $(LOCAL_FULL_LIBS_MANIFEST_FILES)

  ifdef LOCAL_STATIC_JAVA_AAR_LIBRARIES
    my_full_libs_manifest_files += $(foreach lib, $(LOCAL_STATIC_JAVA_AAR_LIBRARIES),\
      $(call intermediates-dir-for,JAVA_LIBRARIES,$(lib),,COMMON)/aar/AndroidManifest.xml)
  endif
endif

ifdef LOCAL_STATIC_JAVA_AAR_LIBRARIES
  # With aapt2, we'll link in the built resource from the AAR.
  ifneq ($(LOCAL_USE_AAPT2),true)
    LOCAL_RESOURCE_DIR += $(foreach lib, $(LOCAL_STATIC_JAVA_AAR_LIBRARIES),\
      $(call intermediates-dir-for,JAVA_LIBRARIES,$(lib),,COMMON)/aar/res)
  endif
endif

# Set up rules to merge library manifest files
ifneq (,$(strip $(my_full_libs_manifest_files)))

main_android_manifest := $(full_android_manifest)
full_android_manifest := $(intermediates.COMMON)/manifest/AndroidManifest.xml
$(full_android_manifest): PRIVATE_LIBS_MANIFESTS := $(my_full_libs_manifest_files)
$(full_android_manifest): $(ANDROID_MANIFEST_MERGER_CLASSPATH)
$(full_android_manifest) : $(main_android_manifest) $(my_full_libs_manifest_files)
	@echo "Merge android manifest files: $@ <-- $< $(PRIVATE_LIBS_MANIFESTS)"
	@mkdir -p $(dir $@)
	$(hide) $(ANDROID_MANIFEST_MERGER) --main $< \
	    --libs $(call normalize-path-list,$(PRIVATE_LIBS_MANIFESTS)) \
	    --out $@

endif
