using Bankcardoperations.Connection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Bankcardoperations.Controllers
{
    public class CustomerController : Controller
    {
      
        DataTable db = new DataTable();
        Connect connect = new Connect();
        Dictionary<string, dynamic> keyValuePairs = new Dictionary<string, dynamic>();

        public ActionResult CustomerLogin()
        {
            return View();
        }

        [HttpPost]
        public ActionResult CustomerLogin(decimal cardnumber, int pin)
        {
            keyValuePairs.Add("CardNumber", cardnumber);
            keyValuePairs.Add("Pin", pin);

            DataTable getdata = connect.GetData("CustomerLogin", keyValuePairs);
            try
            {
                if ((int)getdata.Rows[0]["Status"] == 1)
                {
                    Session["CardNumber"] = cardnumber;
                    Session["Pin"] = pin;
                    return RedirectToAction("CustomerOperations");
                }
                else
                {
                    TempData["ErrorMessage"] = "Not found card :(";
                    return RedirectToAction("CustomerLogin");
                }
            }
            catch (Exception)
            {
                TempData["ErrorMessage"] = "Operation is failed :(";
            }
            return View();
        }
        public ActionResult CustomerOperations()
        {
            keyValuePairs.Add("card_number", Session["CardNumber"]);

            DataTable data = connect.GetData("GetBalanceByCustomer", keyValuePairs);

            return  View(data);
        }

        public ActionResult AddAmount()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddAmount(decimal amount)
        {
            keyValuePairs.Add("addamount", amount);
            keyValuePairs.Add("card_number", Session["CardNumber"]);
            keyValuePairs.Add("add_date", DateTime.Now);
            keyValuePairs.Add("tableStatus", "The amount entered");

            DataTable GetParametr = connect.GetData("AddAmount", keyValuePairs);

            string result = ((int)GetParametr.Rows[0]["Status"]== 1) ? "CustomerOperations" : "CustomerLogin";
            return RedirectToAction(result);
        }

        public ActionResult WithdrawAmount()
        {
            return View();
        }


        [HttpPost]
        public ActionResult WithdrawAmount(decimal Amount)
        {
            keyValuePairs.Add("withdrawamount", Amount);
            keyValuePairs.Add("cardnumber",Session["CardNumber"]);
            keyValuePairs.Add("tableStatus", "The amount withdrawn");
            keyValuePairs.Add("date", DateTime.Now);

            DataTable GtParametr = connect.GetData("WithdrawAmount", keyValuePairs);
            string result=(Convert.ToInt32(GtParametr.Rows[0]["Status"]) == 1)? "CustomerOperations": "CustomerLogin";
            return RedirectToAction(result);
        }

        public ActionResult ChangePin( )
        {
            return View();
        }


        [HttpPost]
        public ActionResult ChangePin(int oldpin, int newpin)
        {
            keyValuePairs.Add("card_number", Session["CardNumber"]);
            keyValuePairs.Add("Oldpin", oldpin);
            keyValuePairs.Add("Newpin", newpin);

            DataTable GetParametr = connect.GetData("ChangePin", keyValuePairs);
            try
            {
                if (Convert.ToInt32(GetParametr.Rows[0]["Pin"]) == newpin) 
                {
                    return RedirectToAction("CustomerLogin");
                }
            }
            catch (Exception)
            {
                TempData["Error_message"] = "Enter correct old pin";
                return RedirectToAction("ChangePin");
            }
            return View();
        }

        public ActionResult History(string card_number )
         {
            if (card_number == null)
            {
                decimal a = Convert.ToDecimal(Session["CardNumber"]);
                keyValuePairs.Add("card_number", a);
            }
            else
            {
                Session["CardNumber"] = card_number;
                keyValuePairs.Add("card_number", decimal.Parse(card_number));
            }

            DataTable GetParametr = connect.GetData("GetOperationByCustomer", keyValuePairs);
            return View(GetParametr);
        }

        public ActionResult Filter()
        {
            return View();
        }


        [HttpPost]
        public ActionResult Filter(string start_date , string end_date )
        {
            decimal s = Convert.ToDecimal(Session["CardNumber"]);

            keyValuePairs.Add("card_number", s);
            keyValuePairs.Add("start_date", start_date);
            keyValuePairs.Add("end_date", end_date);
            DataTable GetParametr = connect.GetData("Filter", keyValuePairs);
            try
            {
                if (GetParametr.Rows[0]["Time"].ToString()!=null)
                {
                    return View(GetParametr);
                }
            }
            catch (Exception)
            {
                TempData["NoFilter"] = "No result found";
                return View(GetParametr);
            }

            return View();
        }
    }
}