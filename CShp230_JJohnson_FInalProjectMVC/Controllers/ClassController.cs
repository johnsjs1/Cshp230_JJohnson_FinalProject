using CShp230_JJohnson_FInalProjectMVC.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace CShp230_JJohnson_FInalProjectMVC.Controllers
{
    public class ClassController : Controller
    {
        AdvWebDevProjectEntities db = new AdvWebDevProjectEntities();
        // GET: Class
        public ActionResult Index()
        {
            return View(db.vClasses.ToList());
        }

        // GET: Class/Details/5
        public ActionResult Details(int id)
        {
            //if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            vClass theClass = db.vClasses.Find(id);
            if (theClass == null) return HttpNotFound();
            return View(theClass);
        }

        // GET: Class/Create
        public ActionResult Create()
        {
            vClass theClass = new vClass();
            return View(theClass);
        }

        // POST: Class/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(vClass theClass)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.vClasses.Add(theClass);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            catch (Exception)
            {
                ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists see your system administrator.");
            }
            return View(theClass);
        }

        // GET: Class/Edit/5
        public ActionResult Edit(int id)
        {
            //if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            vClass theClass = db.vClasses.Find(id);
            if (theClass == null) return HttpNotFound();
            return View(theClass);
        }

        // POST: Class/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(vClass theClass)
        {
                if (ModelState.IsValid)
                {
                if (TryUpdateModel(theClass))
                    try
                    {
                        db.SaveChanges();
                        return RedirectToAction("Index");
                    }
                    catch
                    {
                        ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists see your system administrator.");
                    }
                }
                return View(theClass);
        }

        // GET: Class/Delete/5
        public ActionResult Delete(int id)
        {
            //if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            vClass theClass = db.vClasses.Find(id);
            if (theClass == null) return HttpNotFound();
            return View(theClass);
        }

        // POST: Class/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(vClass theClass)
        {
            if (ModelState.IsValid)
            {
                try {
                    db.vClasses.Remove(theClass);
                    db.SaveChanges();
                    return RedirectToAction("Index"); }
                catch { ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists see your system administrator."); }
            }
            return View(theClass);
        }
    }
}
