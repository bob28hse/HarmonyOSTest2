import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util, buffer } from '@kit.ArkTS';
import { InitConst } from './InitConst';

export class StringUtils {
  private static readonly AES_KEY = "your_16_byte_key";
  private static readonly AES_IV = "your_16_byte_iv_";

  // CryptoFramework cannot auto-detect
  private static getAesAlg(keyLength: number): string {
    if (keyLength === 32) return 'AES256';
    if (keyLength === 24) return 'AES192';
    if (keyLength === 16) return 'AES128';
    throw new Error(`Invalid AES key length: ${keyLength} bytes. Must be 16, 24, or 32.`);
  }

  // pako TOO SLOW
  /*
  public static async aesDecryptJSON<T>(base64Ciphertext: string): Promise<T | undefined> {
    try {
      // 1. Base64 Decode + AES Decrypt

      // AES_Key
      const aesAlg = StringUtils.getAesAlg(InitConst.AES_KEY.length);
      const symKey = await cryptoFramework.createSymKeyGenerator(aesAlg)
        .convertKey({ data: new Uint8Array(buffer.from(InitConst.AES_KEY, 'utf-8').buffer) });

      // IV Spec (Explicit type)
      let ivSpec: cryptoFramework.IvParamsSpec = {
        algName: 'IvParamsSpec',
        iv: { data: new Uint8Array(buffer.from(InitConst.AES_IV, 'utf-8').buffer) }
      };

      // **Start Decode**
      const decoder = cryptoFramework.createCipher(`${aesAlg}|CBC|PKCS7`);
      await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, ivSpec);

      const ciphertext = new util.Base64Helper().decodeSync(base64Ciphertext);
      const decryptBlob = await decoder.doFinal({ data: ciphertext });
      const rawData = decryptBlob.data;

      // 2. In-Memory Gunzip
      let finalString: string;

      // Gzip
      if (rawData[0] === 0x1f && rawData[1] === 0x8b) {
        // Direct in-memory decompression
        const decompressed = pako.ungzip(rawData) as Uint8Array;
        finalString = buffer.from(decompressed).toString('utf-8');
      } else {
        finalString = buffer.from(rawData).toString('utf-8');
      }

      console.log("Final: " + finalString);

      // 3. Unserialize
      return JSON.parse(finalString) as T;

    } catch (err) {
      console.error("Decryption/Decompression failed", err);
      return undefined;
    }
  }
  */
}