export class JsonUtils {
  // Safe String: Always returns a string
  static getString(data: Record<string, Object>, key: string, def: string = ""): string {
    const val = data[key];
    if (typeof val === 'string')
      return val;

    return def;
  }

  // Safe Number: Prevents string-to-number crashes
  static getNumber(data: Record<string, Object>, key: string, def: number = 0): number {
    const val = data[key];
    if (typeof val === 'number')
      return val;
    if (typeof val === 'string') {
      const parsed = Number.parseFloat(val);
      return Number.isNaN(parsed) ? def : parsed;
    }

    return def;
  }

  // Safe Boolean: Handles "true", 1, and true
  static getBoolean(data: Record<string, Object>, key: string, def: boolean = false): boolean {
    const val = data[key];
    if (typeof val === 'boolean')
      return val;
    if (val === 'true' || val === '1' || val === 1)
      return true;

    return def;
  }

  static getRecord(data: Record<string, Object>, key: string, def: Record<string, Object> = {}): Record<string, Object>{
    const val = data[key];
    if (val !== null && typeof val === 'object')
      return val as Record<string, Object>;

    return def;
  }

  // Safe Array: For nesting objects like Pictures
  static getArray(data: Record<string, Object>, key: string, def: Array<Record<string, Object>> = []): Array<Record<string, Object>> {
    const val = data[key];
    if (Array.isArray(val))
      return val as Array<Record<string, Object>>;

    return def;
  }
}
