class ANTConstants {
	// Fitness Equipment device (FE-C)
	// From §7.1 Slave Channel Configuration
    const DEVICE_TYPE = 17; // (0x11) – indicates ANT+ Fitness Equipment
    const TRANSMISSION_TYPE = 0; // 0 for pairing
    const PERIOD_4HZ = 8192;
    const FREQ = 57; // RF Channel 57 (2457 MHz) used for ANT+ FE devices
    const NO_PROXIMITY_SEARCH = 0;
    const DEVICE_NUMBER = 0; // Wildcard, any device number works
    const SEARCH_TIMEOUT_UNITS_S = 2.5f;
    const SEARCH_TIMEOUT_PRIORITY = 4; // In 2.5s increments, 30s max.
}
