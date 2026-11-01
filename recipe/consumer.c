#include <slurm/slurm.h>

int main(void) {
    return slurm_api_version() > 0 ? 0 : 1;
}
