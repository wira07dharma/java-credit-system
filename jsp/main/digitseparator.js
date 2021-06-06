function clearDigitSeparator(amount,separator,decimal){
	total = "";
	for(j=0;j<amount.length;j++){
		switch(amount.charAt(j)){
			case " ":	
				break;
			case separator:
				total = total + amount.charAt(j);
				break;
			case decimal:
				break;
			default:
				var num = new Number(amount.charAt(j));
				if(!isNaN(num)){
					total = total +""+ amount.charAt(j);
				}			
				break;				
		}
	}
	amount = total;
	return amount;
}

function parserNumber(element,boolCheckValue,maxVal,strMessage){
	var digitDecimal = "."; // digit yang untuk desimal simbol
	var digitSeparator = ","; // digit yang dipakai simbol ribuan
	
	var total = element.value;
	var many = total.length;
	var j =0;
	var i =0;
	var strTotalValue = total;
	var strTotalDecimal = "";
	var status = new Boolean();
	status = false;
	
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
			element.focus();
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
		element.value= varValue+digitDecimal+strTotalDecimal; 
	}else{
		if(status){
			element.value= varValue+digitDecimal; 
		}else{
			element.value= varValue; 
		}			
	}
}
//var digitDecimal = "."; // digit yang untuk desimal simbol
//var digitSeparator = ","; // digit yang dipakai simbol ribuan

function formatCurrency(num,separator,decimal) {
	num = num.toString().replace(/\$|\,/g,'');
	if(isNaN(num))
		num = "0";
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num*100+0.50000000001);
	cents = num%100;
	num = Math.floor(num/100).toString();
	if(cents<10)
	cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
		num = num.substring(0,num.length-(4*i+3))+separator+
		num.substring(num.length-(4*i+3));
	return (((sign)?'':'-') + num + decimal + cents);
}

function parserNumberDown(element,boolCheckValue,maxVal,strMessage){
	var digitDecimal = "."; // digit yang untuk desimal simbol
	var digitSeparator = ","; // digit yang dipakai simbol ribuan
	
	var total = element.value;
	var many = total.length;
	var j =0;
	var i =0;
	var strTotalValue = total;
	var strTotalDecimal = "";
	var status = new Boolean();
	status = false;
	
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
			strTotalValue = strTotalValue.substring(0,strTotalValue.length-2);
			element.focus();
		}
	}		
	
	if(strTotalValue.length > 14){
			alert("Erorr nilai tidak disupport");
			element.focus();
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
		element.value= varValue+digitDecimal+strTotalDecimal; 
	}else{
		if(status){
			element.value= varValue+digitDecimal; 
		}else{
			element.value= varValue; 
		}			
	}
}

function parserNumberNew(element,boolCheckValue,maxVal,strMessage,digitSeparator,digitDecimal){
	var total = element.value;
	var many = total.length;
	var j =0;
	var i =0;
	var strTotalValue = total;
	var strTotalDecimal = "";
	var status = new Boolean();
	status = false;
	
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
			element.focus();
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
		element.value= varValue+digitDecimal+strTotalDecimal; 
	}else{
		if(status){
			element.value= varValue+digitDecimal; 
		}else{
			element.value= varValue; 
		}			
	}
}

function formatangka(objek) {
   a = objek.value;
   b = a.replace(/[^\d]/g,"");
   c = "";
   panjang = b.length;
   j = 0;
   for (i = panjang; i > 0; i--) {
     j = j + 1;
     if (((j % 3) == 1) && (j != 1)) {
       c = b.substr(i-1,1) + "," + c;
     } else {
       c = b.substr(i-1,1) + c;
     }
   }
   objek.value = c;
}
