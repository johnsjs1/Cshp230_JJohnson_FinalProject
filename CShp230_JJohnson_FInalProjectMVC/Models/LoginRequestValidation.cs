using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CShp230_JJohnson_FInalProjectMVC.Models
{
    [MetadataType(typeof(LoginRequestValidation))]
    public partial class vLoginRequest { }

    public class LoginRequestValidation
    {
        [Display(Name="Request Number")]
        public int LoginId { get; set; }

        [Display(Name="Student Name")]
        [Required]
        public string Name { get; set; }

        [Display(Name="Student Email")]
        [Required]
        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; }

        [Display(Name = "Student Login")]
        [Required]
        public string LoginName { get; set; }

        [Display(Name = "Request Type")]
        [Required]
        [RegularExpression(@"New|Reactivate")]
        public string NewOrReactivate { get; set; }

        [Display(Name="Reason for Request")]
        [Required]
        [DataType(DataType.MultilineText)]
        public string ReasonForAccess { get; set; }

        [Display(Name="Date Required")]
        [Required]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public Nullable<System.DateTime> DateRequiredBy { get; set; }
    }
}