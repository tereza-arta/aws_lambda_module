variable "source_dir" {
	type        = string
	description = "Directory of target file containing Lambda function"
	default     = "python"
}

variable "func_name" {
	type = string
	description = "Name of Lambda function"
} 

variable "runtime_language" {
	type        = string
	description = "Name and version of Lambda runtime language"
	default     = "python3.8"
}

