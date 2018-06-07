using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web.Mvc;
using CShp230_JJohnson_FInalProjectMVC.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CShp230_JJohnson_FInalProjectMVC.Controllers.Tests
{
    [TestClass()]
    public class StudentControllerTests
    {
        [TestMethod()]
        public void IndexTest()
        {
            var controller = new StudentController();
            var result = controller.Index() as ViewResult;
            Assert.AreEqual("Index", result.View);
        }

        [TestMethod()]
        public void DetailsTest()
        {
            var controller = new StudentController();
            var result = controller.Details(1) as ViewResult;
            Assert.AreEqual("Details", result.ViewName);
        }
    }
}