%include "io64.inc"

%define _MAX_SIZE 65536

section .bss
    ; ------------------------------
    ; Matrix Dimensions
    ; ------------------------------
    A_dim_r resq 1 ; row dimension of matrix A
    A_dim_c resq 1 ; col dimension of matrix B
    B_dim_r resq 1 ; row dimension of matrix B
    B_dim_c resq 1 ; col dimension of matrix A
    
    ; ------------------------------
    ; Matrix Variables
    ; ------------------------------
    A resq _MAX_SIZE ; matrix A
    B resq _MAX_SIZE ; matrix B

section .text
global main
main:
    ; ------------------------------
    ; Entry Point
    ; ------------------------------
    jmp MatrixDim

MatrixDim:
    ; ------------------------------
    ; MatrixDim
    ; FOR:      Handles user input for the dimensions of the matrix
    ; ENSURES:  Matrix rows and columns are valid
    ; ------------------------------
    _get_inputs:
        PRINT_STRING "(Matrix A) # of Rows: "
        GET_DEC 8, rax
        cmp rax, _MAX_SIZE
        jg __err_invalid_dim_range
        
        cmp rax, 0
        jle __err_invalid_dim_range
        
        mov [A_dim_r], rax
        
        NEWLINE
        
        PRINT_STRING "(Matrix A) # of Cols: "
        GET_DEC 8, rax
        cmp rax, _MAX_SIZE
        jg __err_invalid_dim_range
        
        cmp rax, 0
        jle __err_invalid_dim_range
        
        mov [A_dim_c], rax
        
        NEWLINE
        
        PRINT_STRING "(Matrix B) # of Rows: "
        GET_DEC 8, rax
        cmp rax, _MAX_SIZE
        jg __err_invalid_dim_range
        
        cmp rax, 0
        jle __err_invalid_dim_range
        
        mov [B_dim_r], rax
        
        NEWLINE
        
        PRINT_STRING "(Matrix B) # of Cols: "
        GET_DEC 8, rax
        cmp rax, _MAX_SIZE
        jg __err_invalid_dim_range
        
        cmp rax, 0
        jle __err_invalid_dim_range
        
        mov [B_dim_c], rax
        
        NEWLINE
        
        ; Check if the matrix dimensions are valid for
        ; matrix multiplcations        
        mov rax, [A_dim_c]
        mov rbx, [B_dim_r]
        cmp rax, rbx
        jnz __err_invalid_Ar_Bc
        
        jmp PopulateMatrix
        
        __err_invalid_dim_range:
            PRINT_STRING "Matrix dimension should be in [(1,1), (65535, 65536)]" 
            NEWLINE
            jmp _get_inputs

        __err_invalid_Ar_Bc:
            PRINT_STRING "# rows of A must be equal to # cols of B"
            NEWLINE
            jmp _get_inputs

PopulateMatrix:
    ; ------------------------------
    ; PopulateMatrix
    ; FOR:      Handles user input for the entries of both matrices
    ; ------------------------------
    _populate_a:
        mov r8, [A_dim_c]       ; (col) loop bound
        xor rbx, rbx            ; (col) loop ctr
        
        __populate_row_a:
            mov rdx, [A_dim_r]  ; (row) loop bound
            xor rcx, rcx        ; (row) loop ctr
                
            ___a_loop:
                xor rax, rax
                GET_DEC 8, rax
                
                PRINT_DEC 8, rax
                NEWLINE 
                
                mov [A + 8*rcx], rax
                inc rcx
                
                cmp rcx, rdx
                je __populatate_reset_a
                
                jmp ___a_loop
        
        __populatate_reset_a:
            inc rbx
            
            cmp rbx, r8
            je _populate_b
            
            jmp __populate_row_a
            
    _populate_b:
        mov r8, [B_dim_c]       ; (col) loop bound
        xor rbx, rbx            ; (col) loop ctr
        
        __populate_row_b:
            mov rdx, [B_dim_r]  ; (row) loop bound
            xor rcx, rcx        ; (row) loop ctr
                
            ___b_loop:
                xor rax, rax
                GET_DEC 8, rax
                
                PRINT_DEC 8, rax
                NEWLINE 
                
                mov [B + 8*rcx], rax
                inc rcx
                
                cmp rcx, rdx
                je __populatate_reset_b
                
                jmp ___b_loop
        
        __populatate_reset_b:
            inc rbx
            
            cmp rbx, r8
            je done
            
            jmp __populate_row_b
        
done: 
    xor rax, rax
    ret