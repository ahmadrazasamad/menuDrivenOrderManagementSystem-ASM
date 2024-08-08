include emu8086.inc       ;for print

org 100h

.model small
.stack 100h

.data

    welcomMsg db "Welcome to Hotel Taj Mahal! Take a look at our delightful menu below and let us know what you'd like to enjoy.", 10, 10, 13, "$" ; 10 is new line feed while 13 is carriage return
    menuHeading db "                                    Menu", 10, 10, 13, "$"   ;spaces for printing it in the center of the screen

    ;menu starts here
    appetizers db "Appetizers", 10, 10, 13                      ;item name, item description, (price will be in another array
               db "1. Samosa Platter - Rs. 300", 10, 13         ;name
               db "(Crispy pastries filled with spiced potatoes and peas, served with mint chutney)", 10, 10, 13    ;description
               db "2. Pakora Assortment - Rs. 350", 10, 13
               db "(Fritters made from mixed vegetables, coated in a gram flour batter and deep-fried)", 10, 10, 13
               db "3. Chicken Seekh Kebabs - Rs. 450", 10, 13
               db "(Minced chicken mixed with spices and grilled on skewers)", 10, 10, 13
               db "4. Dahi Bhalla - Rs. 400", 10, 13
               db "(Lentil dumplings served with yogurt, tamarind, and mint chutney)", 10, 10, 10, 13, "$"
    apetizersPrice dw 300, 350, 450, 400

    soups db "Soups", 10, 10, 13
          db "1. Chicken Corn Soup - Rs. 300", 10, 13
          db "(A hearty soup made with chicken, sweet corn, and egg ribbons)", 10, 10, 13
          db "2. Mulligatawny Soup - Rs. 350,", 10, 13
          db "(A spiced lentil soup with a blend of traditional Pakistani flavors)", 10 , 10, 10, 13, "$"
    soupsPrice dw 300, 350

    mainCoursesHeading db "Main Courses", 10, 10, 13, "$"
    vegetarian db "Vegetarian", 10, 10, 13
               db "1. Palak Paneer - Rs. 650", 10, 13
               db "(Cottage cheese cubes cooked in a rich spinach gravy)", 10, 10, 13
               db "2. Aloo Gobi - Rs. 600", 10, 13
               db "(Potatoes and cauliflower cooked with tomatoes and spices)", 10, 10, 13
               db "3. Chana Masala - Rs. 550", 10, 13
               db "(Chickpeas simmered in a tangy tomato-based gravy)",10, 10, 13, "$"
    vegeterianPrice dw 650, 600, 550
    nonVegeterian db "Non-Vegetarian", 10, 10, 13
                  db "1. Chicken Karahi - Rs. 900", 10, 13
                  db "(Chicken cooked in a wok with tomatoes, green chilies, and spices)", 10, 10, 13
                  db "2. Mutton Biryani - Rs. 1200", 10, 13
                  db "(Layered rice dish with spiced mutton and saffron)", 10, 10, 13
                  db "3. Beef Nihari - Rs. 950", 10, 13
                  db "(Slow-cooked beef stew with rich spices)", 10, 10, 13
                  db "4. Fish Tikka - Rs. 850", 10, 13
                  db "(Grilled fish marinated in spices and yogurt)", 10, 10, 13, "$"
    nonVegeterianPrice dw 900, 1200, 950, 850

    desserts db "Desserts", 10, 10, 13
             db "1. Gulab Jamun - Rs. 300", 10, 13
             db "(Fried dough balls soaked in sugar syrup)", 10, 10, 13
             db "2. Kheer - Rs. 350", 10, 13
             db "(Rice pudding flavored with cardamom and topped with nuts)", 10, 10, 13
             db "3. Falooda - Rs. 400", 10, 13
             db "(Sweet beverage with vermicelli, basil seeds, jelly, and ice cream)", 10, 10, 13, "$"
    dessertsPrice dw 300, 350, 400

    beverages db "Beverages", 10, 10, 13
              db "1.Masala Chai - Rs. 150", 10, 13
              db "(Spiced tea brewed with milk and traditional spices)", 10, 10, 13
              db "2. Lassi (Sweet or Salted) - Rs. 200", 10, 13
              db "(Traditional yogurt-based drink)", 10, 10 ,13
              db "3. Soft Drinks - Rs. 100", 10, 13
              db "(Cola Next, Bubble Up, Pakola, etc.)", 10, 10, 13
              db "4. Bottled Water - Rs. 50", 10, 10, 13, "$"
    beveragesPrice dw 150, 200, 100, 50
    ;menu end here

    askMsg db "What do you want to order Sir/Mam, from the following:", 10, 13
           db "1. Appetizers", 10, 13
           db "2. Soups", 10, 13
           db "3. Main Courses", 10, 13
           db "4. Desserts", 10, 13
           db "5. Beverages", 10, 13
           db "Enter your choice: $"
    
    getChoiceMsg db "From the above options what do you want to order, enter your choice: $"        
    anythingElseMsg db "Would you like to order anything else, press y to view the menu again and order something and anyother key to view the total bill reciept: $"
        
    invalidCharMsg db "Invalid Character entered, please re-enter choice: $"
    goBackToMenuAsInvalidCharEnt db "Going back to menu as invalid character entered.", 10, 13, "$"
    
    tempInputHolder db ?
    
    countOfOrders db 0      ;for details of orders
    totalBill dw ?
    tempBillAmountHolder dw ?
    
    thousandDigit db ?
    hundredDigit db ?
    tenDigit db ?
    oneDigit db ?

.code

    Main proc
        mov ax, @data       ;copy address of data segment into ax
        mov ds, ax          ;initializes ds to point to the begining of the data segment
    
        lea dx, welcomMsg
        mov ah, 09h
        int 21h
    
        orderTaker:         ;for taking multiple orders
            call printMenu
        
            lea dx, askMsg  ;taking order
            mov ah, 09h
            int 21h
        
            recallerAfterInvalidCharacter:
                call takeInput
            
                mov al, tempInputHolder           ;getting the value back
                cmp al, 1                        
                je processAppetizersOrder
                cmp al, 2
                je processSoupsOrder
                cmp al, 3
                je processMainCourseOrder
                cmp al, 4
                je processDessertsOrder
                cmp al, 5
                je processBeveragesOrder
        
                jmp processInvalidCharacter       ;else case
        
                comeBackBranch:
                    lea dx, anythingElseMsg       ;printing anything else msg   
                    mov ah, 09h
                    int 21h
                    
                    call takeInput
                    mov al, tempInputHolder
                    add al, 30h
                    
                    cmp al, 89                    ;89 is ascii of 'Y'
                    je  orderTaker
                    cmp al, 121                   ;121 is ascii of 'y'
                    je orderTaker
                    
                    jne printReciept              ;else case  
                
        endProgram:
            mov ah, 4ch
            int 21h
            
            ret                                   ;return to the os from dos program
    Main endp

;branches start here
    
    processAppetizersOrder:
        call printAppetizers
        call printGetChoiceMsg
        call takeInput
        mov al, tempInputHolder
        
        cmp al, 1
        je addSamosaPlatterInOrder
        cmp al, 2
        je addPakoraAssortmentInOrder
        cmp al, 3
        je addChickenSeekhKababsInOrder
        cmp al, 4
        je addDahiBhallaInOrder
        
        jmp goBacktoMenu                          ;otherwise
        
        addSamosaPlatterInOrder:
            mov si, offset apetizersPrice
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax           
            inc countOfOrders
            jmp comeBackBranch                    ;branch for going back to main
        ;======================
    
        addPakoraAssortmentInOrder:
            mov si, offset apetizersPrice
            add si, 2
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
    
        addChickenSeekhKababsInOrder:
            mov si, offset apetizersPrice
            add si, 4
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
    
        addDahiBhallaInOrder:
            mov si, offset apetizersPrice
            add si, 6
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================    
    ;======================
    
    processSoupsOrder:
        call printSoups
        call printGetChoiceMsg
        call takeInput
        mov al, tempInputHolder
        
        cmp al, 1
        je addChickenCornSoupInOrder
        cmp al, 2
        je addMulligatawnySoupInOrder
        
        jmp goBacktoMenu                          ;otherwise
        
        addChickenCornSoupInOrder:
            mov si, offset soupsPrice
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch                    ;branch for going back to main
        ;======================
    
        addMulligatawnySoupInOrder:
            mov si, offset soupsPrice
            add si, 2
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
    ;======================
    
    processMainCourseOrder:
        mov dl, 10                                ;printing new line
        mov ah, 02h
        int 21h
        mov dl, 13
        int 21h
        print "Main Course"        
        mov dl, 10                                ;printing new line
        mov ah, 02h
        int 21h
        mov dl, 13
        int 21h
        print "1. Vegeterian"
        mov dl, 10                                ;printing new line
        mov ah, 02h
        int 21h
        mov dl, 13
        int 21h
        print "2. Non-Vegeterian"
        mov dl, 10                                ;printing new line
        mov ah, 02h
        int 21h
        mov dl, 13
        int 21h
        
        call printGetChoiceMsg
        call takeInput
        mov al, tempInputHolder
        
        cmp al, 1
        je orderVegterian
        cmp al, 2
        je orderNonVegeterian
        
        jmp goBacktoMenu                          ;otherwise
        
        orderVegterian:
            call printVegetarian
            call printGetChoiceMsg
            call takeInput
            mov al, tempInputHolder
        
            cmp al, 1
            je addPalakPaneerInOrder
            cmp al, 2
            je addAlooGobiInOrder
            cmp al, 3
            je addChanaMasalaInOrder
            
            jmp goBacktoMenu                          ;otherwise
        
            addPalakPaneerInOrder:
                mov si, offset vegeterianPrice
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch                ;branch for going back to main
            ;======================
        
            addAlooGobiInOrder:
                mov si, offset vegeterianPrice
                add si, 2
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch
            ;======================
        
            addChanaMasalaInOrder:
                mov si, offset vegeterianPrice
                add si, 4
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch    
            ;======================
        ;======================
        
        orderNonVegeterian:
            call printNonVegetarian
            call printGetChoiceMsg
            call takeInput
            mov al, tempInputHolder
        
            cmp al, 1
            je addChickenKarahiInOrder
            cmp al, 2
            je addMuttonBiryaniInOrder
            cmp al, 3
            je addBeefNihariInOrder
            cmp al, 4
            je addFishTikkaInOrder
            
            jmp goBacktoMenu                          ;otherwise
        
            addChickenKarahiInOrder:
                mov si, offset nonVegeterianPrice
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch                ;branch for going back to main
            ;======================
    
            addMuttonBiryaniInOrder:
                mov si, offset nonVegeterianPrice
                add si, 2
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch
            ;======================
    
            addBeefNihariInOrder:
                mov si, offset nonVegeterianPrice
                add si, 4
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch
            ;======================
    
            addFishTikkaInOrder:
                mov si, offset nonVegeterianPrice
                add si, 6
                mov bx, [si]
                mov ax, totalBill
                add ax, bx
                mov totalBill, ax
                inc countOfOrders
                jmp comeBackBranch    
            ;======================
    ;======================
    
    processDessertsOrder:
        call printDesserts
        call printGetChoiceMsg
        call takeInput
        mov al, tempInputHolder
        
        cmp al, 1
        je addGulabJamunInOrder
        cmp al, 2
        je addKheerInOrder
        cmp al, 3
        je addFaloodaInOrder
        
        jmp goBacktoMenu                          ;otherwise
        
        addGulabJamunInOrder:
            mov si, offset dessertsPrice
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch                    ;branch for going back to main
        ;======================
        
        addKheerInOrder:
            mov si, offset dessertsPrice
            add si, 2
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
        
        addFaloodaInOrder:
            mov si, offset dessertsPrice
            add si, 4
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
    ;======================
    
    processBeveragesOrder:
        call printBeverages
        call printGetChoiceMsg
        call takeInput
        mov al, tempInputHolder
        
        cmp al, 1
        je addMasalaChaiInOrder
        cmp al, 2
        je addLassiInOrder
        cmp al, 3
        je addSoftDrinkInOrder
        cmp al, 4
        je addBottledWaterInOrder
        
        jmp goBacktoMenu                          ;otherwise
        
        addMasalaChaiInOrder:
            mov si, offset beveragesPrice
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch                    ;branch for going back to main
        ;======================
        
        addLassiInOrder:
            mov si, offset beveragesPrice
            add si, 2
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
        
        addSoftDrinkInOrder:
            mov si, offset beveragesPrice
            add si, 4
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
        
        addBottledWaterInOrder:
            mov si, offset beveragesPrice
            add si, 6
            mov bx, [si]
            mov ax, totalBill
            add ax, bx
            mov totalBill, ax
            inc countOfOrders
            jmp comeBackBranch
        ;======================
    ;======================
        
    goBacktoMenu:
        lea dx, goBackToMenuAsInvalidCharEnt
        mov ah, 09h
        int 21h
        
        lea dx, askMsg
        mov ah, 09h
        int 21h
        
        jmp recallerAfterInvalidCharacter
    ;======================
    
    printReciept:
        print "You ordered "
        mov dl, countOfOrders
        add dl, 30h
        mov ah, 02h
        int 21h
        print " dishe(s). And your total bill is RS. "
        call printMoney
        print "/-"
        jmp endProgram
    ;======================
    
    processInvalidCharacter:
        call printInvalidCharacter
        jmp recallerAfterInvalidCharacter        
    ;======================
    
;branches end here


;functions start here

    printAppetizers proc
        lea dx, appetizers
        mov ah, 09h
        int 21h
        ret
    printAppetizers endp
    ;======================

    printSoups proc
        lea dx, soups
        mov ah, 09h
        int 21h
        ret
    printSoups endp
    ;======================
    
    printVegetarian proc
        lea dx, vegetarian
        mov ah, 09h
        int 21h
        ret
    printVegetarian endp
    ;======================

    printNonVegetarian proc
        lea dx, nonVegeterian
        mov ah, 09h
        int 21h
        ret
    printNonVegetarian endp
    ;======================

    printDesserts proc
        lea dx, desserts
        mov ah, 09h
        int 21h
        ret
    printDesserts endp
    ;======================

    printBeverages proc
        lea dx, beverages
        mov ah, 09h
        int 21h
        ret
    printBeverages endp
    ;======================

    printMenu proc  
        lea dx, menuHeading
        mov ah, 09h
        int 21h  
      
        call printAppetizers
        call printSoups
    
        lea dx, mainCoursesHeading
        mov ah, 09h
        int 21h
    
        call printVegetarian
        call printNonVegetarian
        call printDesserts
        call printBeverages
    
        ret                                       ;return to the caller
    printMenu endp
    ;======================

    printGetChoiceMsg proc
        lea dx, getChoiceMsg
        mov ah, 09h
        int 21h
        ret
    printGetChoiceMsg endp
    ;======================

    printInvalidCharacter proc
        lea dx, invalidCharMsg
        mov ah, 09h
        int 21h
        ret
    printInvalidCharacter endp
    ;======================
    
    printMoney proc
        mov ax, totalBill
        mov [tempBillAmountHolder], ax
        
        cmp ax, 1000
        jge printThousandBranch
        jl printHundredBranch
        
        printThousandBranch:
            call printThousand
            jmp returnAfterPrintingMoney
        ;======================
        
        printHundredBranch:
            call printHundred    
        
        ;======================
        
        mov ax, tempBillAmountHolder
        mov [totalBill], ax
            
        returnAfterPrintingMoney:
            ret                ;return to the caller    
    printMoney endp
    ;======================
    
    printThousand proc
        ;processing for one (thousand)
        mov ax, 0h             ;clearing ax
        mov ax, totalBill
        mov bx, 0h
        mov bl, 10
    
        div bl
    
        mov oneDigit, ah
        mov totalBill, ax
    
        ;processing for ten (hundred)
        mov ax, 0h             ;clearing ax
        mov ax, totalBill
        mov bl, 10
    
        div bl
    
        mov tenDigit, ah
    
        ;processing for hundred (ten)
        mov ah, 0h             ;clearing ah
        div bl
        mov hundredDigit, ah
    
        ;processing for thousand (one)
        mov ah, 0h             ;clearing ah
        div bl
        mov thousandDigit, ah
    
        ;now printing
        mov dl, thousandDigit
        mov ah, 02h
        add dl, 30h
        int 21h
        mov dl, hundredDigit 
        add dl, 30h
        int 21h
        mov dl, tenDigit 
        add dl, 30h
        int 21h
        mov dl, oneDigit 
        add dl, 30h
        int 21h

        ret    
    printThousand endp    
    ;======================    
    
    printHundred proc
        ;processing for one (hundred)
        mov ax, 0h             ;clearing ax
        mov ax, totalBill
        mov bl, 10
    
        div bl
    
        mov oneDigit, ah
    
        ;processing for ten (ten)
        mov ah, 0h             ;clearing ah
        div bl
        mov tenDigit, ah
    
        ;processing for hundred (one)
        mov ah, 0h             ;clearing ah
        div bl
        mov hundredDigit, ah
    
        ;now printing
        mov dl, hundredDigit 
        add dl, 30h
        mov ah, 02h
        int 21h
        mov dl, tenDigit 
        add dl, 30h
        int 21h
        mov dl, oneDigit 
        add dl, 30h
        int 21h    
        
        ret    
    printHundred endp    
    ;======================
    
    takeInput proc
        mov ah, 01h
        int 21h                                   ;final input will be in al
        sub al, 30h
        mov tempInputHolder, al
    
        mov dl, 10                                ;printing new line
        mov ah, 02h
        int 21h
        mov dl, 13
        int 21h
    
        ret
    takeInput endp
;functions end here

end main