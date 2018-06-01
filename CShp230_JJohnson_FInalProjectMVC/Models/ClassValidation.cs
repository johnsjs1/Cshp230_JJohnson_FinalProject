using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CShp230_JJohnson_FInalProjectMVC.Models
{
    [MetadataType(typeof(ClassValidation))]
    public partial class vClass { }

    public class ClassValidation
    {
        [Display(Name ="Class Number")]
        public int ClassId { get; set; }

        [Required]
        [Display(Name ="Class Name")]
        public string ClassName { get; set; }

        [DataType(DataType.Date)]
        [Display(Name ="Class Date")]
        [DisplayFormat(DataFormatString ="{0:yyyy-MM-dd}",ApplyFormatInEditMode =true)]
        public System.DateTime ClassDate { get; set; }

        [Display(Name ="Class Description")]
        public string ClassDescription { get; set; }

    }
}