library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is port (
  FPGA_CLK1_50       : in  std_logic;
  HPS_CONV_USB_N     : inout  std_logic;
  HPS_DDR3_ADDR      : out   std_logic_vector(14 downto 0);
  HPS_DDR3_BA        : out   std_logic_vector(2 downto 0);
  HPS_DDR3_CAS_N     : out   std_logic;
  HPS_DDR3_CK_N      : out   std_logic;
  HPS_DDR3_CK_P      : out   std_logic;
  HPS_DDR3_CKE       : out   std_logic;
  HPS_DDR3_CS_N      : out   std_logic;
  HPS_DDR3_DM        : out   std_logic_vector(3 downto 0);
  HPS_DDR3_DQ        : inout std_logic_vector(31 downto 0);
  HPS_DDR3_DQS_N     : inout std_logic_vector(3 downto 0);
  HPS_DDR3_DQS_P     : inout std_logic_vector(3 downto 0);
  HPS_DDR3_ODT       : out   std_logic;
  HPS_DDR3_RAS_N     : out   std_logic;
  HPS_DDR3_RESET_N   : out   std_logic;
  HPS_DDR3_RZQ       : in    std_logic;
  HPS_DDR3_WE_N      : out   std_logic;
  HPS_ENET_GTX_CLK   : out   std_logic;
  HPS_ENET_INT_N     : inout std_logic;
  HPS_ENET_MDC       : out   std_logic;
  HPS_ENET_MDIO      : inout std_logic;
  HPS_ENET_RX_CLK    : in    std_logic;
  HPS_ENET_RX_DATA   : in    std_logic_vector(3 downto 0);
  HPS_ENET_RX_DV     : in    std_logic;
  HPS_ENET_TX_DATA   : out   std_logic_vector(3 downto 0);
  HPS_ENET_TX_EN     : out   std_logic;
  HPS_GSENSOR_INT    : inout std_logic;
  HPS_I2C0_SCLK      : inout std_logic;
  HPS_I2C0_SDAT      : inout std_logic;
  HPS_I2C1_SCLK      : inout std_logic;
  HPS_I2C1_SDAT      : inout std_logic;
  HPS_KEY            : inout std_logic;
  HPS_LED            : inout std_logic;
  HPS_LTC_GPIO       : inout std_logic;
  HPS_SD_CLK         : out   std_logic;
  HPS_SD_CMD         : inout std_logic;
  HPS_SD_DATA        : inout std_logic_vector(3 downto 0);
  HPS_SPIM_CLK       : out   std_logic;
  HPS_SPIM_MISO      : in    std_logic;
  HPS_SPIM_MOSI      : out   std_logic;
  HPS_SPIM_SS        : inout std_logic;
  HPS_UART_RX        : in    std_logic;
  HPS_UART_TX        : out   std_logic;
  HPS_USB_CLKOUT     : in    std_logic;
  HPS_USB_DATA       : inout std_logic_vector(7 downto 0);
  HPS_USB_DIR        : in    std_logic;
  HPS_USB_NXT        : in    std_logic;
  HPS_USB_STP        : out   std_logic;
  KEY                : in    std_logic_vector(1 downto 0);
  LED                : out   std_logic_vector(7 downto 0);
  SW                 : in    std_logic_vector(3 downto 0)
);
end top;

architecture rtl of top is
  signal hps_fpga_reset_n : std_logic;
  signal cnt : unsigned(23 downto 0);

component soc is port (
  clk_clk                         : in    std_logic                     := 'X';             -- clk
  h2f_reset_reset_n               : out   std_logic;                                        -- reset_n
  hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
  hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
  hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
  hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
  hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
  hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
  hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
  hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
  hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
  hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
  hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
  hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
  hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
  hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
  hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
  hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
  hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
  hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
  hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
  hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
  hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
  hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
  hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
  hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
  hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
  hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
  hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
  hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
  hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
  hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
  hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
  hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
  hps_io_hps_io_spim1_inst_CLK    : out   std_logic;                                        -- hps_io_spim1_inst_CLK
  hps_io_hps_io_spim1_inst_MOSI   : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
  hps_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
  hps_io_hps_io_spim1_inst_SS0    : out   std_logic;                                        -- hps_io_spim1_inst_SS0
  hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
  hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
  hps_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
  hps_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
  hps_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
  hps_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
  hps_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
  hps_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
  hps_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
  hps_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
  hps_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
  hps_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
  memory_mem_a                    : out   std_logic_vector(14 downto 0);                    -- mem_a
  memory_mem_ba                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
  memory_mem_ck                   : out   std_logic;                                        -- mem_ck
  memory_mem_ck_n                 : out   std_logic;                                        -- mem_ck_n
  memory_mem_cke                  : out   std_logic;                                        -- mem_cke
  memory_mem_cs_n                 : out   std_logic;                                        -- mem_cs_n
  memory_mem_ras_n                : out   std_logic;                                        -- mem_ras_n
  memory_mem_cas_n                : out   std_logic;                                        -- mem_cas_n
  memory_mem_we_n                 : out   std_logic;                                        -- mem_we_n
  memory_mem_reset_n              : out   std_logic;                                        -- mem_reset_n
  memory_mem_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
  memory_mem_dqs                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
  memory_mem_dqs_n                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
  memory_mem_odt                  : out   std_logic;                                        -- mem_odt
  memory_mem_dm                   : out   std_logic_vector(3 downto 0);                     -- mem_dm
  memory_oct_rzqin                : in    std_logic                     := 'X';             -- oct_rzqin
  reset_reset_n                   : in    std_logic                     := 'X'              -- reset_n
);
end component soc;

begin
soc_0 : soc port map (
  clk_clk => FPGA_CLK1_50,
  h2f_reset_reset_n => hps_fpga_reset_n,
  reset_reset_n => hps_fpga_reset_n,
  memory_mem_a => HPS_DDR3_ADDR,
  memory_mem_ba => HPS_DDR3_BA,
  memory_mem_ck => HPS_DDR3_CK_P,
  memory_mem_ck_n => HPS_DDR3_CK_N,
  memory_mem_cke => HPS_DDR3_CKE,
  memory_mem_cs_n => HPS_DDR3_CS_N,
  memory_mem_ras_n => HPS_DDR3_RAS_N,
  memory_mem_cas_n => HPS_DDR3_CAS_N,
  memory_mem_we_n => HPS_DDR3_WE_N,
  memory_mem_reset_n => HPS_DDR3_RESET_N,
  memory_mem_dq => HPS_DDR3_DQ,
  memory_mem_dqs => HPS_DDR3_DQS_P,
  memory_mem_dqs_n => HPS_DDR3_DQS_N,
  memory_mem_odt => HPS_DDR3_ODT,
  memory_mem_dm => HPS_DDR3_DM,
  memory_oct_rzqin => HPS_DDR3_RZQ,
  hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,
  hps_io_hps_io_emac1_inst_TXD0 => HPS_ENET_TX_DATA(0),
  hps_io_hps_io_emac1_inst_TXD1 => HPS_ENET_TX_DATA(1),
  hps_io_hps_io_emac1_inst_TXD2 => HPS_ENET_TX_DATA(2),
  hps_io_hps_io_emac1_inst_TXD3 => HPS_ENET_TX_DATA(3),
  hps_io_hps_io_emac1_inst_RXD0 => HPS_ENET_RX_DATA(0),
  hps_io_hps_io_emac1_inst_RXD1 => HPS_ENET_RX_DATA(1),
  hps_io_hps_io_emac1_inst_RXD2 => HPS_ENET_RX_DATA(2),
  hps_io_hps_io_emac1_inst_RXD3 => HPS_ENET_RX_DATA(3),
  hps_io_hps_io_emac1_inst_MDIO => HPS_ENET_MDIO,
  hps_io_hps_io_emac1_inst_MDC => HPS_ENET_MDC,
  hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,
  hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,
  hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,
  hps_io_hps_io_sdio_inst_CMD => HPS_SD_CMD,
  hps_io_hps_io_sdio_inst_D0 => HPS_SD_DATA(0),
  hps_io_hps_io_sdio_inst_D1 => HPS_SD_DATA(1),
  hps_io_hps_io_sdio_inst_CLK => HPS_SD_CLK,
  hps_io_hps_io_sdio_inst_D2 => HPS_SD_DATA(2),
  hps_io_hps_io_sdio_inst_D3 => HPS_SD_DATA(3),
  hps_io_hps_io_usb1_inst_D0 => HPS_USB_DATA(0),
  hps_io_hps_io_usb1_inst_D1 => HPS_USB_DATA(1),
  hps_io_hps_io_usb1_inst_D2 => HPS_USB_DATA(2),
  hps_io_hps_io_usb1_inst_D3 => HPS_USB_DATA(3),
  hps_io_hps_io_usb1_inst_D4 => HPS_USB_DATA(4),
  hps_io_hps_io_usb1_inst_D5 => HPS_USB_DATA(5),
  hps_io_hps_io_usb1_inst_D6 => HPS_USB_DATA(6),
  hps_io_hps_io_usb1_inst_D7 => HPS_USB_DATA(7),
  hps_io_hps_io_usb1_inst_CLK => HPS_USB_CLKOUT,
  hps_io_hps_io_usb1_inst_STP => HPS_USB_STP,
  hps_io_hps_io_usb1_inst_DIR => HPS_USB_DIR,
  hps_io_hps_io_usb1_inst_NXT => HPS_USB_NXT,
  hps_io_hps_io_spim1_inst_CLK => HPS_SPIM_CLK,
  hps_io_hps_io_spim1_inst_MOSI => HPS_SPIM_MOSI,
  hps_io_hps_io_spim1_inst_MISO => HPS_SPIM_MISO,
  hps_io_hps_io_spim1_inst_SS0 => HPS_SPIM_SS,
  hps_io_hps_io_uart0_inst_RX => HPS_UART_RX,
  hps_io_hps_io_uart0_inst_TX => HPS_UART_TX,
  hps_io_hps_io_i2c0_inst_SDA => HPS_I2C0_SDAT,
  hps_io_hps_io_i2c0_inst_SCL => HPS_I2C0_SCLK,
  hps_io_hps_io_i2c1_inst_SDA => HPS_I2C1_SDAT,
  hps_io_hps_io_i2c1_inst_SCL => HPS_I2C1_SCLK,
  hps_io_hps_io_gpio_inst_GPIO09 => HPS_CONV_USB_N,
  hps_io_hps_io_gpio_inst_GPIO35 => HPS_ENET_INT_N,
  hps_io_hps_io_gpio_inst_GPIO40 => HPS_LTC_GPIO,
  hps_io_hps_io_gpio_inst_GPIO53 => HPS_LED,
  hps_io_hps_io_gpio_inst_GPIO54 => HPS_KEY,
  hps_io_hps_io_gpio_inst_GPIO61 => HPS_GSENSOR_INT
);

process(FPGA_CLK1_50) begin
  if rising_edge(FPGA_CLK1_50) then
    cnt <= cnt + 1;
  end if;
end process;

LED(7 downto 6) <= std_logic_vector(cnt(23 downto 22));

neorv32_top_inst: entity work.neorv32_top
  generic map (
    -- General --
    CLOCK_FREQUENCY              => 50000000,   -- clock frequency of clk_i in Hz
    INT_BOOTLOADER_EN            => false,             -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
    -- RISC-V CPU Extensions --
    CPU_EXTENSION_RISCV_C        => true,              -- implement compressed extension?
    CPU_EXTENSION_RISCV_M        => true,              -- implement mul/div extension?
    CPU_EXTENSION_RISCV_Zicntr   => true,              -- implement base counters?
    -- Internal Instruction memory --
    MEM_INT_IMEM_EN              => true,              -- implement processor-internal instruction memory
    MEM_INT_IMEM_SIZE            => 16*1024, -- size of processor-internal instruction memory in bytes
    -- Internal Data memory --
    MEM_INT_DMEM_EN              => true,              -- implement processor-internal data memory
    MEM_INT_DMEM_SIZE            => 8*1024, -- size of processor-internal data memory in bytes
    -- Processor peripherals --
    IO_GPIO_NUM                  => 8,                 -- number of GPIO input/output pairs (0..64)
    IO_MTIME_EN                  => true               -- implement machine system timer (MTIME)?
  )
  port map (
    -- Global control --
    clk_i  => FPGA_CLK1_50,     -- global clock, rising edge
    rstn_i => hps_fpga_reset_n,    -- global reset, low-active, async
    -- GPIO (available if IO_GPIO_NUM > 0) --
    gpio_o(0) => LED(0), -- parallel output
    gpio_o(1) => LED(1), -- parallel output
    gpio_o(2) => LED(2), -- parallel output
    gpio_o(3) => LED(3), -- parallel output
    gpio_o(4) => LED(4), -- parallel output
    gpio_o(5) => LED(5) -- parallel output
  );

end rtl;

