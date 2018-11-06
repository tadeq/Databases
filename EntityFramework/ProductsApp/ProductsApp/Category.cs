using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductsApp
{
    class Category
    {
        public int CategoryID { get; set; }
        public string Name { get; set; }
        public List<Product> Products { get; set; }
        public string Description { get; set; }
    }
}
