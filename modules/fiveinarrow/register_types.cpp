#include "register_types.h"

#include "core/object/class_db.h"
#include "fiveinarrow.h"

void initialize_fiveinarrow_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
	ClassDB::register_class<FiveInArrow>();
}

void uninitialize_fiveinarrow_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
	// Nothing to do here in this example.
}