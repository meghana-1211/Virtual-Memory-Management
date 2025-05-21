.section .text
.global main

main:

    la t0, supervisor
    csrw mepc,t0        #set mepc to the starting point of supervisor mode
    
    csrr t0, mstatus
    li t1, 0x800
    or t0, t0, t1       
    csrw mstatus,t0     #set MPP bits to 01(supervisor mode)

    mret    #switch to supervisor mode

supervisor:

################ Initialize your page tables here ################

    #set the page table entries accordingly 
    #valid bit is 1,rest of the 10 lsbs are 0 (not for all)->most of the following page table entries
    #The 10 msbs are set to 0

    li t0, 0x81000010
    li t1, 0x00000082000
    
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)

    li t0, 0x82000000
    li t1, 0x00000083000
    
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)

    li t0, 0x83000000
    li t1, 0x00000080000
    
    slli t1, t1, 10
    ori t1, t1, 0x49
    sd  t1, 0(t0)

    li t0, 0x81000000
    li t1, 0x00000082001
    
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)
   
    li t0, 0x82001000
    li t1, 0x00000083001
    
    slli t1, t1, 10
    ori t1, t1, 0x1
    sd  t1, 0(t0)

    li t0, 0x83001000
    li t1, 0x00000080001
    
    slli t1, t1, 10
    ori t1, t1, 0x59
    sd  t1, 0(t0)
   
    li t0, 0x83001008
    li t1, 0x00000080002
    
    slli t1, t1, 10
    ori t1, t1, 0x53
    sd  t1, 0(t0)

####################################################################
  
    #set sstatus to enable privilege switch to user mode

    li t0, 0xFFFFFEFF
    csrr t1, sstatus
    and t1, t1, t0        
    csrw sstatus,t1 

################ DO NOT MODIFY THESE INSTRUCTIONS ################
    la t1, satp_config # load satp val
    ld t2, 0(t1)
    sfence.vma zero, zero
    csrrw zero, satp, t2
    sfence.vma zero, zero

    li t4, 0
    csrrw zero, sepc, t4 
    sret
####################################################################


########### For the below part, only align the sections ############
########### and  fill in the value for satp_config #################
.align 12
user_code:
    la t1,var1
    la t2,var2
    la t3,var3
    la t4,var4
    j user_code

.data
.align 12
var1:  .word  1
var2:  .word  2
var3:  .word  3
var4:  .word  4
.align 12
satp_config: .dword 0x8000000000081000 # Value to set in satp

############################ END OF CODE ############################