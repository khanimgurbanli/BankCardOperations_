using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Bankcardoperations.Connection
{
	public class Connect
	{
		public string ConnectionString="Data Source=DESKTOP-PV88HK2;Initial Catalog=BankCardOperations;Integrated Security=True";
		public DataTable GetData(string ProcedurName, Dictionary<string, dynamic> Parametrs=null)
        {
			DataTable dataTable = new DataTable();
			 

			SqlConnection sqlConnection = new SqlConnection(ConnectionString);

			sqlConnection.Open();

			SqlCommand sqlCommand = new SqlCommand(ProcedurName,sqlConnection);
			sqlCommand.CommandType = CommandType.StoredProcedure;

            foreach (KeyValuePair<string,dynamic> parametr in Parametrs)
            {
				SqlParameter sqlParameter = new SqlParameter();
				sqlParameter.ParameterName = parametr.Key;
				sqlParameter.Value = parametr.Value;
				sqlCommand.Parameters.Add(sqlParameter);
            }

			SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
			sqlDataAdapter.Fill(dataTable);

			return dataTable;
        }
	}
}