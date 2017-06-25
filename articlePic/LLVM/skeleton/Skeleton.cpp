#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Instructions.h"

using namespace llvm;

namespace {
  struct SkeletonPass : public FunctionPass {
    static char ID;
    SkeletonPass() : FunctionPass(ID) {}

    // virtual bool runOnFunction(Function &F) {
    //   errs() << "I saw a function called " << F.getName() << "!\n";
    //   return false;
    // }
    bool runOnFunction(Function &F) override {
            Function *tmp = &F;
            // 遍历函数中的所有基本块
            for (Function::iterator bb = tmp->begin(); bb != tmp->end(); ++bb) {
                // 遍历基本块中的每条指令
                for (BasicBlock::iterator inst = bb->begin(); inst != bb->end(); ++inst) {
                    // 是否是add指令
                    if (inst->isBinaryOp()) {
                        if (inst->getOpcode() == Instruction::Add) {
                            ob_add(cast<BinaryOperator>(inst));
                        }
                    }
                }
            }
             
            return false;
        }
         
        // a+b === a-(-b)
        bool ob_add(BinaryOperator *bo) {
            BinaryOperator *op = NULL;
             
            if (bo->getOpcode() == Instruction::Add) {
                // 生成 (－b)
                op = BinaryOperator::CreateNeg(bo->getOperand(1), "", bo);
                // 生成 a-(-b)
                op = BinaryOperator::Create(Instruction::Sub, bo->getOperand(0), op, "", bo);
                 
                op->setHasNoSignedWrap(bo->hasNoSignedWrap());
                op->setHasNoUnsignedWrap(bo->hasNoUnsignedWrap());
            }
             
            // 替换所有出现该指令的地方
            bo->replaceAllUsesWith(op);
        }
  };
}

char SkeletonPass::ID = 0;

// Automatically enable the pass.
// http://adriansampson.net/blog/clangpass.html
static void registerSkeletonPass(const PassManagerBuilder &,
                         legacy::PassManagerBase &PM) {
  PM.add(new SkeletonPass());
}
static RegisterStandardPasses
  RegisterMyPass(PassManagerBuilder::EP_EarlyAsPossible,
                 registerSkeletonPass);
