#https://www.jeffgeerling.com/blog/2025/increasing-vram-allocation-on-amd-ai-apus-under-linux/

# Calculation: `([size in GB] * 1024 * 1024) / 4.096`

# CL?  48*1024*1024*1024 /4096 = 12582912

#sudo grubby --update-kernel=ALL --args='amdttm.pages_limit=27648000'

sudo grubby --update-kernel=ALL --args='amdttm.pages_limit=12582912'

#sudo grubby --update-kernel=ALL --args='amdttm.page_pool_size=27648000'

sudo grubby --update-kernel=ALL --args='amdttm.page_pool_size=12582912'

#sudo reboot

#To verify do"
#sudo grubby --info ALL

#after boot do:
#sudo dmesg | grep "amdgpu.*memory"  DOES NOT WORK mem limits still the same
#
#also see with
#rocm-smi --showmeminfo GTT VRAM
#rocm-smi --showmemuse
#radeontop -c
