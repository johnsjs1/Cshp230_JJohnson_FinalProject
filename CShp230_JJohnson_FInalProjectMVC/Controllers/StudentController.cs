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
        // GET: Student
        public ActionResult Index()
        {
            var db = new AdvWebDevProjectEntities();
            return View(db.vStudents.ToList());
        }

        // GET: Student/Details/5
        public ActionResult Details(int id)
        {
            var db = new AdvWebDevProjectEntities();
            var theStudent = db.vStudents.Find(id);
            if (theStudent == null) return HttpNotFound();
            return View(theStudent);
        }

        // GET: Student/Create
        public ActionResult Create()
        {
            return View(new vStudent());
        }

        // POST: Student/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(vStudent theStudent)
        {
            using (var db = new AdvWebDevProjectEntities())
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
                catch (Exception ex)
                {
                    ModelState.AddModelError("",
                        $"An error occurred: {ex.Message}");
                }
            }
            return View(theStudent);
        }

        // GET: Student/Edit/5
        public ActionResult Edit(int id)
        {
            var db = new AdvWebDevProjectEntities();
            vStudent theStudent = db.vStudents.Find(id);
            if (theStudent == null) return HttpNotFound();
            return View(theStudent);
        }

        // POST: Student/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(vStudent theStudent)
        {
            using (var db = new AdvWebDevProjectEntities())
            {
                if (ModelState.IsValid) //verifies that the data submitted in the form can be used to modify (edit or update)
                {
                    if (TryUpdateModel(theStudent))
                        try
                        {
                            db.SaveChanges();
                            return RedirectToAction("Index");
                        }
                        catch (Exception ex)
                        {
                            ModelState.AddModelError("",
                                $"An error occurred: {ex.Message}");
                        }
                }
            }
                return View(theStudent);
        }

        // GET: Student/Delete/5
        public ActionResult Delete(int id)
        {
            var db = new AdvWebDevProjectEntities();
            vStudent theStudent = db.vStudents.Find(id);
            if (theStudent == null) return HttpNotFound();
            return View(theStudent);
        }

        // POST: Student/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(vStudent theStudent)
        {
            using (var db = new AdvWebDevProjectEntities())
            {
                if (ModelState.IsValid)
                {
                    try
                    {
                        db.Entry(theStudent).State = System.Data.Entity.EntityState.Deleted;
                        db.vStudents.Remove(theStudent);
                        db.SaveChanges();
                        return RedirectToAction("Index");
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("",
                            $"An error occurred: {ex.Message}");
                    }
                }
                else ModelState.AddModelError("", "Model state was invalid.");
            }
            return View(theStudent);
        }
    }
}
