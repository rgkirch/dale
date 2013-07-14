#ifndef DALE_MODULE_WRITER
#define DALE_MODULE_WRITER

#include "../../Context/Context.h"
#include "llvm/Bitcode/ReaderWriter.h"
#include "llvm/Module.h"

#include <string>

namespace dale
{
namespace Module
{

/*! Writer

    A class for writing Dale modules to disk.
*/

class Writer
{
private:
    /*! The name of the module. */
    std::string module_name;
    /*! The path prefix for the module. */
    std::string module_prefix;
    /*! The context for the module. */
    dale::Context *ctx;
    /*! The LLVM module for the module. */
    llvm::Module *mod;
    /*! The LLVM pass manager for the module. */
    llvm::PassManager *pm;
    /*! The once tags for the module. */
    std::set<std::string> *included_once_tags;
    /*! The modules included by way of this module. */
    std::set<std::string> *included_modules;
    /*! Whether the module is a compile-time-only module. */
    bool cto;
    /*! Write the module's bitcode to disk.
     *  @param suffix A string to append to the module name. */
    bool writeBitcode(const char *suffix);
    /*! Write the module's shared object to disk.
     *  @param suffix A string to append to the module name. */
    bool writeSharedObject(const char *suffix);
    /*! Write the module's context to disk. */
    bool writeContext(void);

public:
    /*! The standard constructor. */
    Writer(std::string module_name, dale::Context *ctx, 
           llvm::Module *mod, llvm::PassManager *pm,
           std::set<std::string> *included_once_tags,
           std::set<std::string> *included_modules,
           bool cto);
    ~Writer();

    /*! Write the standard module artifacts to disk. */
    bool run(void);
};
}
}

#endif
