import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util, buffer } from '@kit.ArkTS';
import { zlib } from '@kit.BasicServicesKit'; // Standard Kit
import { fileIo as fs } from '@kit.CoreFileKit';

export class StringUtils {
  static async aesDecryptJSON(base64Ciphertext: string, context: Context): Promise<object | null> {
    const KEY_STR = "your_16_byte_key";
    const IV_STR = "your_16_byte_iv_";

    try {
      // 1. AES Decrypt (Strict API 20 Typing)
      let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let keyData = new Uint8Array(buffer.from(KEY_STR, 'utf-8').buffer);
      let symKey = await symKeyGenerator.convertKey({ data: keyData });

      let decoder = cryptoFramework.createCipher('AES128|CBC|PKCS7');
      let ivData = new Uint8Array(buffer.from(IV_STR, 'utf-8').buffer);
      let ivSpec: cryptoFramework.IvParamsSpec = { algName: 'IvParamsSpec', iv: { data: ivData } };
      await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, ivSpec);

      let ciphertext = new util.Base64Helper().decodeSync(base64Ciphertext);
      let decryptBlob = await decoder.doFinal({ data: ciphertext });
      let rawData = decryptBlob.data;

      // 2. Gzip Logic (Handled via sandboxed file if decompressData is missing)
      let finalJson: string;
      if (rawData[0] === 0x1f && rawData[1] === 0x8b) {
        // Replicates Swift's gunzipped() via sandboxed temp file
        finalJson = await StringUtils.stableGunzip(rawData, context);
      } else {
        finalJson = buffer.from(rawData).toString('utf-8');
      }

      return JSON.parse(finalJson);
    } catch (err) {
      console.error("Decryption pipeline failed", err);
      return null;
    }
  }

  /**
   * Ensures compatibility across all API 20 builds by using the
   * guaranteed decompressFile API.
   */
  static async stableGunzip(data: Uint8Array, context: Context): Promise<string> {
    const tempIn = `${context.tempDir}/temp.gz`;
    const tempOut = `${context.tempDir}/out`;

    // Write buffer to temp sandbox file
    let file = fs.openSync(tempIn, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    fs.writeSync(file.fd, data.buffer);
    fs.closeSync(file);

    // Standard API 20 file decompression
    await zlib.decompressFile(tempIn, tempOut);

    // Read result
    let resFile = fs.openSync(tempOut, fs.OpenMode.READ_ONLY);
    let stat = fs.statSync(tempOut);
    let buf = new ArrayBuffer(stat.size);
    fs.readSync(resFile.fd, buf);
    fs.closeSync(resFile);

    return buffer.from(buf).toString('utf-8');
  }

  // ----------------------
  static isJsonString(str: string): boolean {
    try {
      JSON.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}
