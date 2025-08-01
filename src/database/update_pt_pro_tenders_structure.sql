-- 删除旧的pt_pro_tenders表并重新创建
DROP TABLE IF EXISTS `pt_pro_tenders`;

CREATE TABLE `pt_pro_tenders` (
    `id` VARCHAR(50) PRIMARY KEY,
    `pro_id` VARCHAR(50) NOT NULL COMMENT '项目ID',
    `pro_code` VARCHAR(100) DEFAULT NULL COMMENT '项目代码',
    `pro_name` VARCHAR(500) DEFAULT NULL COMMENT '项目名称',
    `village_code` VARCHAR(20) DEFAULT NULL COMMENT '村代码',
    `tenders_code` VARCHAR(10) DEFAULT NULL COMMENT '投标代码',
    `transfer_year` INT DEFAULT 0 COMMENT '转让年份',
    `transfer_month` INT DEFAULT 0 COMMENT '转让月份',
    `tenders_desc` TEXT COMMENT '投标描述',
    `trade_area` DECIMAL(10,4) DEFAULT 0.0000 COMMENT '交易面积',
    `lq_spl` VARCHAR(100) DEFAULT NULL COMMENT '林权审批',
    `lq_gyl` VARCHAR(100) DEFAULT NULL COMMENT '林权国有林',
    `area_unit` VARCHAR(50) DEFAULT NULL COMMENT '面积单位',
    `lq_zs` VARCHAR(100) DEFAULT NULL COMMENT '林权证书',
    `lq_lmxj` VARCHAR(100) DEFAULT NULL COMMENT '林权林木蓄积',
    `jtzcgq_jysl` VARCHAR(100) DEFAULT NULL COMMENT '集体资产股权交易数量',
    `jtzcgq_zzgbl` VARCHAR(100) DEFAULT NULL COMMENT '集体资产股权占比比例',
    `signup_fee` DECIMAL(10,2) DEFAULT 0.00 COMMENT '报名费',
    `margin` DECIMAL(10,2) DEFAULT 0.00 COMMENT '保证金',
    `price_type` VARCHAR(10) DEFAULT '0' COMMENT '价格类型',
    `expect_price` DECIMAL(15,2) DEFAULT 0.00 COMMENT '预期价格',
    `expect_price_unit` VARCHAR(10) DEFAULT '1' COMMENT '预期价格单位',
    `publish_status` VARCHAR(10) DEFAULT '1' COMMENT '发布状态',
    `publish_date` DATETIME DEFAULT NULL COMMENT '发布日期',
    `publish_er` VARCHAR(100) DEFAULT NULL COMMENT '发布人',
    `sz_east` VARCHAR(100) DEFAULT NULL COMMENT '四至东',
    `sz_south` VARCHAR(100) DEFAULT NULL COMMENT '四至南',
    `sz_west` VARCHAR(100) DEFAULT NULL COMMENT '四至西',
    `sz_north` VARCHAR(100) DEFAULT NULL COMMENT '四至北',
    `remark` TEXT COMMENT '备注',
    `fwf_status` VARCHAR(10) DEFAULT '1' COMMENT '服务费状态',
    `fwf_souce` VARCHAR(10) DEFAULT 'SFF' COMMENT '服务费来源',
    `fwf_rule` VARCHAR(10) DEFAULT 'RATIO' COMMENT '服务费规则',
    `fwf_crf_num` VARCHAR(100) DEFAULT NULL COMMENT '服务费成交人费',
    `fwf_srf_num` DECIMAL(5,2) DEFAULT 0.50 COMMENT '服务费受让人费',
    `status` TINYINT DEFAULT 0 COMMENT '状态',
    `is_stop` TINYINT DEFAULT 0 COMMENT '是否停止',
    `stop_by` VARCHAR(100) DEFAULT NULL COMMENT '停止人',
    `stop_reason` TEXT COMMENT '停止原因',
    `stop_date` DATETIME DEFAULT NULL COMMENT '停止日期',
    `create_by` VARCHAR(100) DEFAULT '' COMMENT '创建人',
    `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
    `update_by` VARCHAR(100) DEFAULT '' COMMENT '更新人',
    `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
    `is_del` TINYINT DEFAULT 1 COMMENT '删除标记',
    `loss_tenders_reason` TEXT COMMENT '流标原因',
    `loss_tenders_date` DATETIME DEFAULT NULL COMMENT '流标日期',
    `pay_type` VARCHAR(10) DEFAULT NULL COMMENT '支付类型',
    `signup_notice_date` DATETIME DEFAULT NULL COMMENT '报名通知日期',
    `signup_start_date` DATETIME DEFAULT NULL COMMENT '报名开始日期',
    `signup_end_date` DATETIME DEFAULT NULL COMMENT '报名结束日期',
    `signup_address` VARCHAR(500) DEFAULT NULL COMMENT '报名地址',
    `signup_lxr` VARCHAR(100) DEFAULT NULL COMMENT '报名联系人',
    `signup_lxdh` VARCHAR(20) DEFAULT NULL COMMENT '报名联系电话',
    `submit_date` DATETIME DEFAULT NULL COMMENT '提交日期',
    `submit_by` VARCHAR(100) DEFAULT NULL COMMENT '提交人',
    `is_relisting` TINYINT DEFAULT 0 COMMENT '是否重新挂牌',
    `is_bg` TINYINT DEFAULT 0 COMMENT '是否变更',
    `bg_time` DATETIME DEFAULT NULL COMMENT '变更时间',
    `bg_by` VARCHAR(100) DEFAULT NULL COMMENT '变更人',
    `stop_stage` VARCHAR(100) DEFAULT NULL COMMENT '停止阶段',
    `bus_flow` TINYINT DEFAULT 1 COMMENT '业务流程',
    `approval_time` DATETIME DEFAULT NULL COMMENT '审批时间',
    `resources_message_uuid` VARCHAR(100) DEFAULT NULL COMMENT '资源消息UUID',
    `unified_deal_code` VARCHAR(100) DEFAULT NULL COMMENT '统一交易代码',
    `acct_no` VARCHAR(100) DEFAULT NULL COMMENT '账户号',
    `acct_no_createtime` DATETIME DEFAULT NULL COMMENT '账户号创建时间',
    `bank_auth_code` VARCHAR(100) DEFAULT NULL COMMENT '银行授权代码',
    `fwf_jsfs` VARCHAR(100) DEFAULT NULL COMMENT '服务费结算方式',
    `xm_ggq` VARCHAR(100) DEFAULT NULL COMMENT '项目公告期',
    `pro_type` VARCHAR(10) DEFAULT NULL COMMENT '项目类型',
    `pro_child_type` VARCHAR(10) DEFAULT NULL COMMENT '项目子类型',
    `extra_json` TEXT COMMENT '额外JSON数据',
    `margin_pay_type` VARCHAR(100) DEFAULT NULL COMMENT '保证金支付类型',
    `reg_fee_pay_type` VARCHAR(100) DEFAULT NULL COMMENT '注册费支付类型',
    `is_recommend` TINYINT DEFAULT 0 COMMENT '是否推荐',
    `real_end_date` DATETIME DEFAULT NULL COMMENT '实际结束日期',
    `price_status` VARCHAR(10) DEFAULT '0' COMMENT '价格状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目投标表';

-- 创建索引
CREATE INDEX idx_pt_pro_tenders_pro_id ON pt_pro_tenders(pro_id);
CREATE INDEX idx_pt_pro_tenders_pro_code ON pt_pro_tenders(pro_code);
CREATE INDEX idx_pt_pro_tenders_village_code ON pt_pro_tenders(village_code);
CREATE INDEX idx_pt_pro_tenders_status ON pt_pro_tenders(status);
CREATE INDEX idx_pt_pro_tenders_pro_type ON pt_pro_tenders(pro_type); 