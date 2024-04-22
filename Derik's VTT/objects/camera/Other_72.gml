//.ZIP Save Status Handling
if zip_save_status = "saving" {
	
	//Retreive Data
	var data_id = async_load[?"id"];
	var data_status =  async_load[?"status"];
	
	//Data Received
	if (zip_save_id == data_id)
	{
		
		//Successful Save
		if data_status = 0 {
			
			//Clear Status 
			zip_save_status = undefined;
			
		}
		
		//Failed Save
		if data_status = -1 {
			
			//Update Status
			zip_save_status = "failed";
		}	
		
		//Clear ID 
		zip_save_id = undefined;
		
	}
}