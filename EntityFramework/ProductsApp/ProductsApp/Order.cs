using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductsApp
{
    class Order
    {
        public int OrderID { get; set; }
        public int CustomerID { get; set; }
        public List<OrderDetails> Details { get; set; }
    }
}
