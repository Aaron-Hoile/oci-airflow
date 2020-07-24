resource "oci_mysql_mysql_db_system" "airflow_database" {
    count = "${var.airflow_database == "mysql-oci" ? 1 : 0}"
    admin_password = "${var.mysqladmin_password}"
    admin_username = "${var.mysqladmin_username}"
    availability_domain = "${var.availability_domain}"
    compartment_id = "${var.compartment_ocid}"
    configuration_id = "${data.oci_mysql_mysql_configurations.airflow_mysql_configurations.0.id}"
    shape_name = "${var.mysql_shape}"
    subnet_id = "${var.subnet_id}"
    backup_policy {
    is_enabled        = "${var.enable_mysql_backups}"
    retention_in_days = "10"
    }
    description = "Airflow Database"
    ip_address    = "${var.oci_mysql_ip}"
    port          = "3306"
    port_x        = "33306"
}

data "oci_mysql_mysql_configurations" "airflow_mysql_configurations" {
  count = "${var.airflow_database == "mysql-oci" ? 1 : 0}"
  compartment_id = "${var.compartment_ocid}"
  state        = "ACTIVE"
  display_name = "${var.mysql_shape}Built-in"
  shape_name   = "${var.mysql_shape}"
}

data "oci_mysql_mysql_db_system" "airflow_database" {
  count = "${var.airflow_database == "mysql-oci" ? 1 : 0}"
  db_system_id = "${oci_mysql_mysql_db_system.airflow_database.0.id}"
}
