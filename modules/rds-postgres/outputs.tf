output "address" {
  value = "${aws_db_instance.spoke.address}"
}

output "port" {
  value = "${aws_db_instance.spoke.port}"
}

output "name" {
  value = "${aws_db_instance.spoke.name}"
}

output "username" {
  value = "${aws_db_instance.spoke.username}"
}
