namespace ProductsApp
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.prodListButton = new System.Windows.Forms.Button();
            this.welcome = new System.Windows.Forms.Label();
            this.orderButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // prodListButton
            // 
            this.prodListButton.Location = new System.Drawing.Point(216, 54);
            this.prodListButton.Name = "prodListButton";
            this.prodListButton.Size = new System.Drawing.Size(176, 65);
            this.prodListButton.TabIndex = 0;
            this.prodListButton.Text = "Products List";
            this.prodListButton.UseVisualStyleBackColor = true;
            this.prodListButton.Click += new System.EventHandler(this.ProdList_Click);
            // 
            // welcome
            // 
            this.welcome.AutoSize = true;
            this.welcome.Font = new System.Drawing.Font("Microsoft Sans Serif", 13.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
            this.welcome.Location = new System.Drawing.Point(245, 9);
            this.welcome.Name = "welcome";
            this.welcome.Size = new System.Drawing.Size(121, 29);
            this.welcome.TabIndex = 3;
            this.welcome.Text = "Welcome!";
            // 
            // orderButton
            // 
            this.orderButton.Location = new System.Drawing.Point(216, 125);
            this.orderButton.Name = "orderButton";
            this.orderButton.Size = new System.Drawing.Size(176, 65);
            this.orderButton.TabIndex = 4;
            this.orderButton.Text = "Order";
            this.orderButton.UseVisualStyleBackColor = true;
            this.orderButton.Click += new System.EventHandler(this.Order_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(618, 331);
            this.Controls.Add(this.orderButton);
            this.Controls.Add(this.welcome);
            this.Controls.Add(this.prodListButton);
            this.Name = "MainForm";
            this.Text = "MainForm";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button prodListButton;
        private System.Windows.Forms.Label welcome;
        private System.Windows.Forms.Button orderButton;
    }
}