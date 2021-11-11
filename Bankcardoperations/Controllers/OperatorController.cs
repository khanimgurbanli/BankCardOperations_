using Bankcardoperations.Connection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;
using System.Net;
using System.Text.RegularExpressions;

namespace Bankcardoperations.Controllers
{
    public class OperatorController : Controller
    {
        DataTable dataTable = new DataTable();
        Connect conn = new Connect();
        Dictionary<string, dynamic> keyValuePairs = new Dictionary<string, dynamic>();

        public ActionResult OperatorLogin()
        {
            return View();
        }

        [HttpPost]
        public ActionResult OperatorLogin(int pin)
        {
            keyValuePairs.Add("pin",pin);

            DataTable dataTable = conn.GetData("OperatorLogin", keyValuePairs);

            try
            {
                if ((int)dataTable.Rows[0]["Status"] == 1)
                {
                    Session["Pin"] = pin;
                    return RedirectToAction("OperatorOperations");
                }
                else
                {
                    TempData["ErrorMessage"] = "Not found user :(";
                    return RedirectToAction("OperatorLogin");
                }
            }
            catch (Exception)
            {
               TempData["Exception"] = "Operation is failed";
                return RedirectToAction("OperatorLogin");
            }
        }

        public ActionResult OperatorOperations()
        {
            string StoreProc = "GetAllCards";
            DataTable getdata = conn.GetData(StoreProc, keyValuePairs);

            return View(getdata);
        }
      
        public ActionResult AcceptCardRequest(string card_number)
        {
            int status = 1;

            keyValuePairs.Add("status", status);
            keyValuePairs.Add("cardnumber", decimal.Parse(card_number));

            DataTable acceptcard = conn.GetData("AcceptCardRequest", keyValuePairs);

            if ((int)acceptcard.Rows[0]["Status"]==1)
            {
                MailMessage msg = new MailMessage();
                msg.From = new MailAddress("bankcardoperations@gmail.com", "Bank N ");
                msg.Subject = "Your card has been activated";
                msg.To.Add(acceptcard.Rows[0]["Email"].ToString());
                msg.Body = $"Pin:{acceptcard.Rows[0]["Pin"].ToString()} \nCard number:{acceptcard.Rows[0]["CardNumber"].ToString()}";
                msg.IsBodyHtml = true;

                SmtpClient client = new SmtpClient();
                client.UseDefaultCredentials = false;
                client.Host = "smtp.gmail.com";
                client.Port = 587;
                client.EnableSsl = true;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.Credentials = new NetworkCredential("bankcardoperations@gmail.com", "bankcard18");
                client.Timeout = 20000;
                client.Send(msg);

                return RedirectToAction("OperatorOperations");
            }
            else
            {
                return Content("Operation is failed");
            }


        }
        public ActionResult Delete(string card_number)
        {
            int delete_card = 2;

            keyValuePairs.Add("Status",delete_card);
            keyValuePairs.Add("CardNumber", decimal.Parse(card_number));

            DataTable deletecard = conn.GetData("DeleteCard", keyValuePairs);

            string result = ((int)deletecard.Rows[0]["Status"] == 0? "OperatorOperations" : "OperatorOperations");
            return RedirectToAction(result);
        }

        
        public ActionResult RejectCardRequest(string card_number )
        {
            int reject_card = -1;

            keyValuePairs.Add("status", reject_card);
            keyValuePairs.Add("card_number", decimal.Parse(card_number));

            DataTable rejectcard = conn.GetData("RejectCardRequest", keyValuePairs);

            string result = ((int)rejectcard.Rows[0]["Status"] == -1 ? "OperatorOperations" : "OperatorOperations");
            return RedirectToAction(result);
        }


        public ActionResult CreateNewCard()
        {
            return View();
        }


        [HttpPost]
        public ActionResult CreateNewCard(string name, string surname, string birthdate, string mail)
        {
            if (String.IsNullOrEmpty(name) || String.IsNullOrEmpty(surname) || String.IsNullOrEmpty(birthdate) || String.IsNullOrEmpty(mail))
            {
                TempData["ForEmptyFields"] = "Fill in all the fields in the correct format";
                return RedirectToAction("CreateNewCard");
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
                    return RedirectToAction("CreateNewCard");
                }

                int cast_birth = Convert.ToInt32(birthdate.Substring(0, 4));
                string now_date = DateTime.Now.Year.ToString();

                if (cast_birth > 1930 && cast_birth < Convert.ToInt32(now_date))
                {
                    keyValuePairs.Add("Birthdate", birthdate.Trim());
                }
                else
                {
                    TempData["BirthdatError"] = "Please Enter a valid date";
                    return RedirectToAction("CreateNewCard");
                }

                int status = 1;
                keyValuePairs.Add("Status", status);
                keyValuePairs.Add("Time", DateTime.Now);

                DataTable GetParametr = conn.GetData("CreateNewCard", keyValuePairs);

                TempData["ApplyForCard"] = "Created card";
                return RedirectToAction("OperatorOperations");
            }
        }

        public ActionResult ChangeCardInfo(string card_number, string name, string surname, string birthdate, string email, string pin)
        {
            Session["CardNumber"] = card_number;
            Session["Name"] = name;
            Session["Surname"] = surname;
            Session["Birthdate"] = birthdate;
            Session["Email"] = email;
            Session["Pin"] = pin;
            return View();
        }

        [HttpPost]
        public ActionResult ChangeCardInfo(string card_number, string name, string surname, string birthdate, string email, int pin)
        {
            try
            {
               keyValuePairs.Add("CardNumber",decimal.Parse(card_number.Trim()));
               keyValuePairs.Add("Name", name.Trim());
               keyValuePairs.Add("Surname", surname.Trim());
               keyValuePairs.Add("Birthdate", birthdate.Trim());
               keyValuePairs.Add("Email", email.Trim());
               keyValuePairs.Add("Pin", Convert.ToInt32((pin.ToString().Trim())));

               DataTable change_ingo = conn.GetData("ChangeCardInfo", keyValuePairs);

                 TempData["ChangeSuccesMessage"] = "The change was saved!";
                 return RedirectToAction("OperatorOperations");
            }
            catch (Exception)
            {
                TempData["ChangeErrorMessage"] = "No changes were saved";
                return RedirectToAction("ChangeCardInfo");
            }    
        }
    }
}