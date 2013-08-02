function validate()
{
    $.ajax({
        url:"/app/ui/ajax/field-validation.xqy?name="+this.id+"&value="+this.value,
        id : this.id,
        method:"get",
        dataType:"json",
        success : function(response,status,xhr) {
        	var key = this.id.replace("-values","").replace("-default","");
        	if(response[key])
    		{
        		$("#"+this.id+"_comment").text(response[key]);
        		$("#"+this.id).focus().addClass("errorcell");        		
    		}
        	else
    		{
        		$("#"+this.id+"_comment").text("");
        		$("#"+this.id).removeClass("errorcell");        		
    		}
        }
    }); 
}
