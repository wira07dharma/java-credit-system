function parserNumber(value,boolCheckValue,maxVal,strMessage){
    var digitDecimal = "."; // digit yang untuk desimal simbol
    var digitSeparator = ","; // digit yang dipakai simbol ribuan

    var total = value;
    var many = total.length;
    var j =0;
    var i =0;
    var strTotalValue = total;
    var strTotalDecimal = "";
    var status = new Boolean();
    status = false;

    var returnVal ="";

    // reformat
    total = "";
    for(j=0;j<strTotalValue.length;j++){
        switch(strTotalValue.charAt(j)){
            case " ":	
                break;
            case digitDecimal:
                total = total + strTotalValue.charAt(j);
                break;
            case digitSeparator:
                break;
            default:
                var num = new Number(strTotalValue.charAt(j));
                if(!isNaN(num)){
                        total = total +""+ strTotalValue.charAt(j);
                }			
            break;				
        }
    }
    strTotalValue = total;
    if(boolCheckValue){
        if(parseFloat(strTotalValue) > parseFloat(maxVal)){
            alert(strMessage);
            strTotalValue = strTotalValue.substring(0,strTotalValue.length-1);
            //element.focus();
        }

    }		

// untuk membedakan value dan desimal
    for(j=0;j<many;j++){
        switch(total.charAt(j)){
            case digitDecimal:
                strTotalDecimal = total.substring(j+1,many);
                strTotalValue = total.substring(0,j);
                status = true;
                break;
        }
    }

// parser
    var x = parseInt(strTotalValue.length) % 3;
    var varValue = "";
    var maxInt = 0;
    for(j=0;j<strTotalValue.length;j++){
        varValue = varValue + strTotalValue.charAt(j);
        maxInt = maxInt + 1;
        if(strTotalValue.length > 3) {
            if(maxInt==3){
                if((strTotalValue.length-1) != j){
                    varValue = varValue + digitSeparator;
                    maxInt = 0;
                }
            }else{
                if(varValue.length < 3){
                    if(x==maxInt){
                        if(strTotalValue.length > 3){
                            varValue = varValue + digitSeparator;
                            maxInt = 0;
                        }
                    }
                }
            }
        }			
    }

    if(strTotalDecimal.length > 0){
       returnVal= varValue+digitDecimal+strTotalDecimal; 
    }else{
        if(status){
            returnVal= varValue+digitDecimal; 
        }else{
            returnVal= varValue; 
        }			
    }

    return returnVal;
}




