using CShp230_JJohnson_FInalProjectMVC.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CShp230_JJohnson_FInalProjectMVC.Controllers
{
    public class StudentController : Controller
    {
        AdvWebDevProjectEntities db = new AdvWebDevProjectEntities();

        // GET: Student
        public ActionResult Index()
        {
            return View(db.vStudents.ToList());
        }

        // GET: Student/Details/5
        public ActionResult Details(int id)
        {
            var theStudent = db.vStudents.Find(id);
            if (theStudent == null) return HttpNotFound();
            return View(theStudent);
        }

        // GET: Student/Create
        public ActionResult Create()
        {
            vStudent theStudent = new vStudent();
            return View(theStudent);
        }

        // POST: Student/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(vStudent theStudent)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.vStudents.Add(theStudent);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            catch (Exception)
            {
                ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists see your system administrator.");
            }
            return View(theStudent);
        }

        // GET: Student/Edit/5
        public ActionResult Edit(int id)
        {
            vStudent theStudent = db.vStudents.Find(id);
            if (theStudent == null) return HttpNotFound();
            return View(theStudent);
        }

        // POST: Student/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(vStudent theStudent)
        {
            if (ModelState.IsValid) //verifies that the data submitted in the form can be used to modify (edit or update)
            {
                if (TryUpdateModel(theStudent))
                    try
                    {
                        db.SaveChanges();
                        return RedirectToAction("Index");
                    }
                    catch
                    {
                        ModelState.AddModelError("", 
                            "Unable to save changes. Try again, and if the problem persists see your system administrator.");
                    }
            }
                return View(theStudent);
        }

        // GET: Student/Delete/5
        public ActionResult Delete(int id)
        {
            vStudent theStudent = db.vStudents.Find(id);
            if (theStudent == null) return HttpNotFound();
            return View(theStudent);
        }

        // POST: Student/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(vStudent theStudent)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    db.vStudents.Remove(theStudent);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                catch (DbUpdateConcurrencyException)
                {
                    ModelState.AddModelError("",
                        $"Item with id {theStudent.StudentId} no longer exists in the database.");
                }
                catch
                { ModelState.AddModelError("",
                    "Unable to save changes. Try again, and if the problem persists see your system administrator."); }
            }
            return View(theStudent);
        }
    }
}
