using CShp230_JJohnson_FInalProjectMVC.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CShp230_JJohnson_FInalProjectMVC.Controllers
{
    public class LoginRequestController : Controller
    {
        AdvWebDevProjectEntities db = new AdvWebDevProjectEntities();
        // GET: LoginRequest
        public ActionResult Index()
        {
            return View(db.vLoginRequests.ToList());
        }

        // GET: LoginRequest/Details/5
        public ActionResult Details(int id)
        {
            vLoginRequest theRequest = db.vLoginRequests.Find(id);
            if (theRequest == null) return HttpNotFound();
            return View(theRequest);
        }

        // GET: LoginRequest/Create
        public ActionResult Create()
        {
            return View(new vLoginRequest());
        }

        // POST: LoginRequest/Create
        [HttpPost]
        public ActionResult Create(vLoginRequest theRequest)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.vLoginRequests.Add(theRequest);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            catch (Exception)
            {
                ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists see your system administrator.");
            }
            return View(theRequest);
        }

        // GET: LoginRequest/Edit/5
        public ActionResult Edit(int id)
        {
            vLoginRequest theRequest = db.vLoginRequests.Find(id);
            if (theRequest == null) return HttpNotFound();
            return View(theRequest);
        }

        // POST: LoginRequest/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(vLoginRequest theRequest)
        {
            throw new NotImplementedException();
        }

        // GET: LoginRequest/Delete/5
        public ActionResult Delete(int id)
        {
            vLoginRequest theRequest = db.vLoginRequests.Find(id);
            if (theRequest == null) return HttpNotFound();
            return View(theRequest);
        }

        // POST: LoginRequest/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(vLoginRequest theRequest)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.vLoginRequests.Remove(theRequest);
                    
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", $"An error occurred: {ex.Message}");
            }
            return View(theRequest);
        }
    }
}
