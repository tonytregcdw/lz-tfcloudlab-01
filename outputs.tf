output "ttvmlist" {
  value = local.vms_01
}

output "scriptfile" {
  value = textdecodebase64(setupscript)
}
