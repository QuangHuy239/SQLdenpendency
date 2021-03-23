﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Project
{
    public partial class Update : Form
    {
        int position = 0;
        public Update()
        {
            InitializeComponent();
        }

        private void nhanVienBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.nhanVienBindingSource.EndEdit();
            this.tableAdapterManager.UpdateAll(this.chuyenDeCNPMDataSet);

        }

        private void Update_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'chuyenDeCNPMDataSet.NhanVien' table. You can move, or remove it, as needed.
            this.nhanVienTableAdapter.Fill(this.chuyenDeCNPMDataSet.NhanVien);

        }

        private void button_Them_Click(object sender, EventArgs e)
        {
            position = nhanVienBindingSource.Position;
            this.nhanVienBindingSource.AddNew();
            txt_manv.Enabled = false;
        }

        private void button_Xoa_Click(object sender, EventArgs e)
        {
            int maNV = 0;
            DialogResult dr = MessageBox.Show("Bạn có thực sự muốn xóa nhân viên này không?", "Xác nhận",
                MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            if (dr == DialogResult.OK)
            {
                try
                {
                    maNV = int.Parse(((DataRowView)nhanVienBindingSource[nhanVienBindingSource.Position])["manv"].ToString());
                    nhanVienBindingSource.RemoveCurrent();
                    this.nhanVienTableAdapter.Update(this.chuyenDeCNPMDataSet.NhanVien);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Lỗi xảy ra trong quá trình xóa. Vui lòng thử lại!\n" + ex.Message, "Thông báo lỗi",
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    this.nhanVienTableAdapter.Fill(this.chuyenDeCNPMDataSet.NhanVien);
                    nhanVienBindingSource.Position = nhanVienBindingSource.Find("manv", maNV);
                    return;
                }
            }
        }

        private void button_Ghi_Click(object sender, EventArgs e)
        {
            if (ValidateChildren(ValidationConstraints.Enabled))
            {
                DialogResult dr = MessageBox.Show("Bạn có chắc muốn ghi dữ liệu vào Database?", "Thông báo",
                        MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                if (dr == DialogResult.OK)
                {
                    try
                    {
                        this.nhanVienBindingSource.EndEdit();
                        this.nhanVienTableAdapter.Update(this.chuyenDeCNPMDataSet.NhanVien);
                        MessageBox.Show("Ghi thành công", "Thông báo", MessageBoxButtons.OK);
                    }
                    catch (Exception ex)
                    {
                        // Khi Update database lỗi thì xóa record vừa thêm trong bds
                        nhanVienBindingSource.RemoveCurrent();
                        MessageBox.Show("Thất bại. Vui lòng kiểm tra lại!\n" + ex.Message, "Lỗi",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void txt_ho_Validating(object sender, CancelEventArgs e)
        {
            var regexItem = new Regex("^[a-zA-Z]*$");
            if (string.IsNullOrWhiteSpace(txt_ho.Text))
            {
                e.Cancel = true;
                txt_ho.Focus();
                errorProvider1.SetError(txt_ho, "Họ không được để trống!");
            }
            else if (!regexItem.IsMatch(txt_ho.Text.Trim()))
            {
                e.Cancel = true;
                txt_ho.Focus();
                errorProvider1.SetError(txt_ho, "Họ chỉ được chứa chữ cái!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txt_ho, "");
            }
        }

        private void txt_ten_Validating(object sender, CancelEventArgs e)
        {
            var regexItem = new Regex("^[a-zA-Z]*$");
            if (string.IsNullOrWhiteSpace(txt_ten.Text))
            {
                e.Cancel = true;
                txt_ten.Focus();
                errorProvider1.SetError(txt_ten, "Tên không được để trống!");
            }
            else if (!regexItem.IsMatch(txt_ho.Text.Trim()))
            {
                e.Cancel = true;
                txt_ten.Focus();
                errorProvider1.SetError(txt_ten, "Tên chỉ được chứa chữ cái!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txt_ten, "");
            }
        }

        private void txt_phai_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_phai.Text))
            {
                e.Cancel = true;
                txt_phai.Focus();
                errorProvider1.SetError(txt_phai, "Phái không được để trống!");
            }
            else if((!txt_phai.Text.Trim().Equals("NAM", StringComparison.OrdinalIgnoreCase)) 
                && (!txt_phai.Text.Trim().Equals("NỮ", StringComparison.OrdinalIgnoreCase)) )
            {
                e.Cancel = true;
                txt_phai.Focus();
                errorProvider1.SetError(txt_phai, "Chỉ được chọn NAM/NỮ");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txt_phai, "");
            }
        }

        private void txt_luong_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) &&
        (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // only allow one decimal point
            if ((e.KeyChar == '.') && ((sender as TextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }

        private void txt_diachi_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_diachi.Text))
            {
                e.Cancel = true;
                txt_diachi.Focus();
                errorProvider1.SetError(txt_diachi, "Địa chỉ không được để trống!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txt_diachi, "");
            }
        }
    }
}
