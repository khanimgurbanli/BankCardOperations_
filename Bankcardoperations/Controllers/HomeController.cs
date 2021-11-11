using Bankcardoperations.Connection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Bankcardoperations.Controllers
{
    public class HomeController : Controller
    {
        DataTable db = new DataTable();
        Connect connect = new Connect();
        Dictionary<string, dynamic> keyValuePairs = new Dictionary<string, dynamic>();


        public ActionResult Index()
        {
            return View();
        }
        public ActionResult NewCard()
        {
            return View();
        }
       

        [HttpPost]
        public ActionResult NewCard(string name, string surname, string birthdate, string mail)
        {
            if (String.IsNullOrEmpty(name) || String.IsNullOrEmpty(surname) || String.IsNullOrEmpty(birthdate) || String.IsNullOrEmpty(mail))
            {
                TempData["ForEmptyFields"] = "Fill in all the fields in the correct format";
                return RedirectToAction("NewCard");
            }
            else
            {
                string first_letterOfName = name[0].ToString().Trim().ToUpper();
                string other_lettersOfName = name.Substring(1).ToLower();
                string CorrecName = first_letterOfName + other_lettersOfName;

                keyValuePairs.Add("Name", CorrecName);

                char first_letterOfSurname = char.ToUpper(surname.Trim()[0]);
                string other_lettersOfSurname = surname.Substring(1).ToLower();
                string CorrectSurname = first_letterOfSurname + other_lettersOfSurname;

                keyValuePairs.Add("Surname", CorrectSurname);

                if (Regex.IsMatch(mail, @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"))
                {
                    int mail_index = mail.IndexOf("@");

                    if (String.Compare("@gmail.com", mail.Substring(mail_index).ToLower()) == 0 || String.Compare("@hotmail.com", mail.Substring(mail_index).ToLower()) == 0)
                    {
                        keyValuePairs.Add("Email", mail.Trim().ToLower());
                    }
                    else 
                    {
                        if (mail.Substring(mail_index + 1, 1) == "g")
                        {
                            keyValuePairs.Add("Email", mail.Replace(mail.Substring(mail_index), "@gmail.com").Trim().ToLower());
                        }
                        else if (mail.Substring(mail_index + 1, 1) == "h")
                        {
                            keyValuePairs.Add("Email", mail.Replace(mail.Substring(mail_index), "@hotmail.com").Trim().ToLower());
                        }
                        else
                        {
                            TempData["MailNotfound"] = "Such an email address does not exist";
                            return RedirectToAction("NewCard");
                        }
                    }
                }
                else
                {
                   TempData["IncorrectFormatEmail"] = "Make sure you enter the correct email and try again";
                   return RedirectToAction("NewCard");
                }

                int cast_birth = Convert.ToInt32(birthdate.Substring(0, 4));
                string now_date =DateTime.Now.Year.ToString();

                if (cast_birth> 1930 && cast_birth< Convert.ToInt32(now_date))
                {
                    keyValuePairs.Add("Birthdate", birthdate.Trim());
                }
                else
                {
                    TempData["BirthdatError"] = "Please Enter a valid date";
                    return RedirectToAction("NewCard");
                }
                int status = 0;
                keyValuePairs.Add("Status", status);
                keyValuePairs.Add("Time", DateTime.Now);

                DataTable GetParametr = connect.GetData("CreateNewCard", keyValuePairs);

                TempData["ApplyForCard"] = "Your card application has been sent";

                return RedirectToAction("NewCard");
            }
        }
    }
}