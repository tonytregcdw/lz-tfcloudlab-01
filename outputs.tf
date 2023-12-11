output "ttvmlist" {
  value = local.vms_01
}

output "scriptfile" {
  value = textdecodebase64(local.setupscript, "UTF-16LE")
}
