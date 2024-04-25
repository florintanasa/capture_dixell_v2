-- Create timescaledb extension
create extension timescaledb;

CREATE TABLE CR2 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  temp_set DOUBLE PRECISION  NOT NULL,
  humid_set DOUBLE PRECISION  NOT NULL,
  compressor_out BOOLEAN  NOT NULL,
  heater_out BOOLEAN  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  humidifier_out BOOLEAN  NOT NULL,
  defrost_out BOOLEAN  NOT NULL,
  light_out BOOLEAN  NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  keyboard_status BOOLEAN  NOT NULL,
  code_13 TEXT NOT NULL
);

CREATE TABLE CR3 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  temp_set DOUBLE PRECISION  NOT NULL,
  humid_set DOUBLE PRECISION  NOT NULL,
  compressor_out BOOLEAN  NOT NULL,
  heater_out BOOLEAN  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  humidifier_out BOOLEAN  NOT NULL,
  defrost_out BOOLEAN  NOT NULL,
  light_out BOOLEAN  NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  keyboard_status BOOLEAN  NOT NULL,
  code_13 TEXT NOT NULL
);

CREATE TABLE CR4 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  temp_set DOUBLE PRECISION  NOT NULL,
  humid_set DOUBLE PRECISION  NOT NULL,
  compressor_out BOOLEAN  NOT NULL,
  heater_out BOOLEAN  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  humidifier_out BOOLEAN  NOT NULL,
  defrost_out BOOLEAN  NOT NULL,
  light_out BOOLEAN  NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  keyboard_status BOOLEAN  NOT NULL,
  code_13 TEXT NOT NULL
);

CREATE TABLE CR9 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  temp_set DOUBLE PRECISION  NOT NULL,
  humid_set DOUBLE PRECISION  NOT NULL,
  compressor_out BOOLEAN  NOT NULL,
  heater_out BOOLEAN  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  humidifier_out BOOLEAN  NOT NULL,
  defrost_out BOOLEAN  NOT NULL,
  light_out BOOLEAN  NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  keyboard_status BOOLEAN  NOT NULL,
  code_13 TEXT NOT NULL
);

CREATE TABLE CC5 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  probe_r DOUBLE PRECISION  NOT NULL,
  setpoint_r DOUBLE PRECISION  NOT NULL,
  setpoint DOUBLE PRECISION  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  compressor_out BOOLEAN NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  code_8 BOOLEAN  NOT NULL,
  code_9 BOOLEAN  NOT NULL,
  code_10 TEXT NOT NULL
);

CREATE TABLE CC6 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  probe_r DOUBLE PRECISION  NOT NULL,
  setpoint_r DOUBLE PRECISION  NOT NULL,
  setpoint DOUBLE PRECISION  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  compressor_out BOOLEAN NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  code_8 BOOLEAN  NOT NULL,
  code_9 BOOLEAN  NOT NULL,
  code_10 TEXT NOT NULL
);

CREATE TABLE CC7 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  probe_r DOUBLE PRECISION  NOT NULL,
  setpoint_r DOUBLE PRECISION  NOT NULL,
  setpoint DOUBLE PRECISION  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  compressor_out BOOLEAN NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  code_8 BOOLEAN  NOT NULL,
  code_9 BOOLEAN  NOT NULL,
  code_10 TEXT NOT NULL
);

CREATE TABLE CC8 (
  datetime TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  address INTEGER NOT NULL,
  code_1 BOOLEAN  NOT NULL,
  code_2 BOOLEAN  NOT NULL,
  probe_1 DOUBLE PRECISION  NOT NULL,
  probe_2 DOUBLE PRECISION  NOT NULL,
  probe_3 DOUBLE PRECISION  NOT NULL,
  probe_r DOUBLE PRECISION  NOT NULL,
  setpoint_r DOUBLE PRECISION  NOT NULL,
  setpoint DOUBLE PRECISION  NOT NULL,
  fan_out BOOLEAN  NOT NULL,
  compressor_out BOOLEAN NOT NULL,
  gdi BOOLEAN  NOT NULL,
  on_status BOOLEAN  NOT NULL,
  defrost_status BOOLEAN  NOT NULL,
  code_8 BOOLEAN  NOT NULL,
  code_9 BOOLEAN  NOT NULL,
  code_10 TEXT NOT NULL
);

-- Then we convert it into a hypertable that is partitioned by time
SELECT create_hypertable('CR2', 'datetime');
SELECT create_hypertable('CR3', 'datetime');
SELECT create_hypertable('CR4', 'datetime');
SELECT create_hypertable('CR9', 'datetime');
SELECT create_hypertable('CC5', 'datetime');
SELECT create_hypertable('CC6', 'datetime');
SELECT create_hypertable('CC7', 'datetime');
SELECT create_hypertable('CC8', 'datetime');
