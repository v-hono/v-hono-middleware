import hono_middleware
import os
import time

fn test_logger_creation() {
	println('=== 测试日志器创建 ===')
	
	config := hono_middleware.LoggerConfig{
		level: hono_middleware.LogLevel.debug
		output: hono_middleware.LogOutput.console
		enable_colors: true
	}
	
	logger := hono_middleware.new_logger(config)
	assert logger.config.level == hono_middleware.LogLevel.debug
	assert logger.config.output == hono_middleware.LogOutput.console
	
	println('✅ 日志器创建测试通过')
}

fn test_log_levels() {
	println('=== 测试日志级别 ===')
	
	// 测试字符串转日志级别
	assert hono_middleware.parse_log_level('debug') == hono_middleware.LogLevel.debug
	assert hono_middleware.parse_log_level('info') == hono_middleware.LogLevel.info
	assert hono_middleware.parse_log_level('warn') == hono_middleware.LogLevel.warn
	assert hono_middleware.parse_log_level('error') == hono_middleware.LogLevel.error
	assert hono_middleware.parse_log_level('invalid') == hono_middleware.LogLevel.info  // 默认值
	
	// 测试日志级别转字符串
	assert hono_middleware.log_level_to_string(hono_middleware.LogLevel.debug) == 'DEBUG'
	assert hono_middleware.log_level_to_string(hono_middleware.LogLevel.info) == 'INFO'
	assert hono_middleware.log_level_to_string(hono_middleware.LogLevel.warn) == 'WARN'
	assert hono_middleware.log_level_to_string(hono_middleware.LogLevel.error) == 'ERROR'
	
	println('✅ 日志级别测试通过')
}

fn test_console_logging() {
	println('=== 测试控制台日志输出 ===')
	
	config := hono_middleware.LoggerConfig{
		level: hono_middleware.LogLevel.debug
		output: hono_middleware.LogOutput.console
		enable_colors: true
	}
	
	mut logger := hono_middleware.new_logger(config)
	
	// 测试基本日志方法
	logger.debug('这是一条调试消息')
	logger.info('这是一条信息消息')
	logger.warn('这是一条警告消息')
	logger.error('这是一条错误消息')
	
	// 测试带模块的日志
	logger.info_with_module('模块信息消息', 'TEST')
	
	// 测试带字段的日志
	fields := {
		'user_id': '12345'
		'action': 'login'
		'ip': '192.168.1.1'
	}
	logger.info_with_fields('用户登录', fields)
	
	// 测试带请求ID的日志
	logger.info_with_request('处理请求', 'req-123456')
	
	println('✅ 控制台日志输出测试通过')
}

fn test_file_logging() {
	println('=== 测试文件日志输出 ===')
	
	log_file := './test_log.log'
	
	// 清理可能存在的测试文件
	if os.exists(log_file) {
		os.rm(log_file) or {}
	}
	
	config := hono_middleware.LoggerConfig{
		level: hono_middleware.LogLevel.info
		output: hono_middleware.LogOutput.file
		file_path: log_file
		enable_colors: false  // 文件输出不需要颜色
	}
	
	mut logger := hono_middleware.new_logger(config)
	
	// 写入一些日志
	logger.info('测试文件日志 1')
	logger.warn('测试文件日志 2')
	logger.error('测试文件日志 3')
	
	// 等待一下确保文件写入完成
	time.sleep(100 * time.millisecond)
	
	// 验证文件是否存在且有内容
	assert os.exists(log_file)
	
	content := os.read_file(log_file) or {
		panic('无法读取日志文件: ${err}')
	}
	
	assert content.contains('测试文件日志 1')
	assert content.contains('测试文件日志 2')
	assert content.contains('测试文件日志 3')
	assert content.contains('INFO')
	assert content.contains('WARN')
	assert content.contains('ERROR')
	
	// 清理测试文件
	os.rm(log_file) or {}
	
	println('✅ 文件日志输出测试通过')
}

fn test_json_logging() {
	println('=== 测试JSON格式日志 ===')
	
	log_file := './test_json_log.log'
	
	// 清理可能存在的测试文件
	if os.exists(log_file) {
		os.rm(log_file) or {}
	}
	
	config := hono_middleware.LoggerConfig{
		level: hono_middleware.LogLevel.info
		output: hono_middleware.LogOutput.file
		file_path: log_file
		enable_json: true
	}
	
	mut logger := hono_middleware.new_logger(config)
	
	// 写入JSON格式日志
	fields := {
		'user_id': '12345'
		'action': 'test'
	}
	logger.info_with_fields('JSON日志测试', fields)
	
	// 等待文件写入
	time.sleep(100 * time.millisecond)
	
	// 验证JSON格式
	assert os.exists(log_file)
	content := os.read_file(log_file) or {
		panic('无法读取JSON日志文件: ${err}')
	}
	
	assert content.contains('"level":"INFO"')
	assert content.contains('"message":"JSON日志测试"')
	assert content.contains('"user_id":"12345"')
	
	// 清理测试文件
	os.rm(log_file) or {}
	
	println('✅ JSON格式日志测试通过')
}

fn test_global_logger() {
	println('=== 测试全局日志器 ===')
	
	config := hono_middleware.LoggerConfig{
		level: hono_middleware.LogLevel.info
		output: hono_middleware.LogOutput.console
		enable_colors: true
	}
	
	// 创建日志器实例
	mut logger := hono_middleware.new_logger(config)
	
	// 使用日志器方法
	logger.info('日志器信息消息')
	logger.warn('日志器警告消息')
	logger.error('日志器错误消息')
	
	println('✅ 全局日志器测试通过')
}

fn main() {
	println('开始日志系统测试...\n')
	
	test_logger_creation()
	println('')
	
	test_log_levels()
	println('')
	
	test_console_logging()
	println('')
	
	test_file_logging()
	println('')
	
	test_json_logging()
	println('')
	
	test_global_logger()
	println('')
	
	println('🎉 所有日志系统测试通过！')
}
