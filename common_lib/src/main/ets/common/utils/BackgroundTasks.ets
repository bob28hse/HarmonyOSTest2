// BackgroundTasks.ets
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util, buffer } from '@kit.ArkTS';
import { zlib } from '@kit.BasicServicesKit';

@Concurrent
export async function decryptAndParseTask<T>(ciphertext: string, aesKey: string, aesIv: string): Promise<T | undefined> {
  try {
    console.time('decryptTimer');

    const keyBytes = new Uint8Array(buffer.from(aesKey, 'utf-8').buffer);
    const ivBytes = new Uint8Array(buffer.from(aesIv, 'utf-8').buffer);

    // 1. Setup AES Algorithm
    const keyLen = keyBytes.length;
    let aesAlg = 'AES128';
    if (keyLen === 32)
      aesAlg = 'AES256';
    else if (keyLen === 24)
      aesAlg = 'AES192';

    // 2. Generate Key
    const symKey = await cryptoFramework.createSymKeyGenerator(aesAlg).convertKey({ data: keyBytes });
    let ivSpec: cryptoFramework.IvParamsSpec = {
      algName: 'IvParamsSpec',
      iv: { data: ivBytes }
    };

    // 3. Decrypt
    const cipher = cryptoFramework.createCipher(`${aesAlg}|CBC|PKCS7`);
    await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, ivSpec);
    const decodedBuffer = new util.Base64Helper().decodeSync(ciphertext);
    const decryptBlob = await cipher.doFinal({ data: decodedBuffer });
    const rawData = decryptBlob.data;
    console.timeLog('decryptTimer');

    // 4. Native Decompression (**MAIN ISSUE)
    let finalString: string = "";
    if (rawData[0] === 0x1f && rawData[1] === 0x8b) {
      const zip = zlib.createZipSync();
      const strm: zlib.ZStream = {};

      /*
      const CHUNK_SIZE = 1024 * 1024; // 1MB chunks
      let outChunks: Uint8Array[] = [];
      let totalExtracted = 0;

      // Setup stream as you did
      await zip.inflateInit2(strm, 31);
      strm.nextIn = rawData.buffer as ArrayBuffer;
      strm.availableIn = rawData.byteLength;

      let result: number;
      do {
        const tempBuffer = new ArrayBuffer(CHUNK_SIZE);
        strm.nextOut = tempBuffer;
        strm.availableOut = tempBuffer.byteLength;

        // Inflate chunk by chunk
        result = await zip.inflate(strm, zlib.CompressFlushMode.NO_FLUSH);

        // totalOut for this specific chunk is (Initial size - remaining)
        const bytesRead = CHUNK_SIZE - strm.availableOut;
        if (bytesRead > 0) {
          outChunks.push(new Uint8Array(tempBuffer, 0, bytesRead));
          totalExtracted += bytesRead;
        }

      } while (strm.availableIn > 0 && result !== 1); // 1 == zlib.Z_STREAM_END

      await zip.inflateEnd(strm);

      // Combine chunks into one final Uint8Array
      const actualBytes = new Uint8Array(totalExtracted);
      let offset = 0;
      for (const chunk of outChunks) {
        actualBytes.set(chunk, offset);
        offset += chunk.length;
      }

      const decoder = util.TextDecoder.create('utf-8');
      finalString = decoder.decodeToString(actualBytes);
      */


      // 15 is the standard for zlib; adding 16 (total 31) tells it to handle Gzip headers
      await zip.inflateInit2(strm, 31);

      // Pre-allocate a large enough output buffer
      const outBuffer = new ArrayBuffer(20 * 1024 * 1024);
      strm.nextIn = rawData.buffer as ArrayBuffer;
      strm.availableIn = rawData.byteLength;
      strm.nextOut = outBuffer;
      strm.availableOut = outBuffer.byteLength;

      await zip.inflate(strm, zlib.CompressFlushMode.FINISH);
      await zip.inflateEnd(strm);

      const actualBytes = new Uint8Array(outBuffer, 0, strm.totalOut);

      // Regex method only returns first one (*Using deprecated 'decode' is a bit faster)
      let decoder = util.TextDecoder.create('utf-8');
      finalString = decoder.decodeToString(actualBytes);
      const match = finalString.match(/^\{[\s\S]*\}|\[[\s\S]*\]/);
      if (match)
        finalString = match[0];

    } else {
      finalString = buffer.from(rawData).toString('utf-8');
    }

    console.timeLog('decryptTimer');
    console.log("After unzip: " + finalString);

    // 5. Parse JSON
    const result = JSON.parse(finalString) as T;
    console.timeEnd('decryptTimer');

    return result;

  } catch (err) {
    console.error("TaskPool Decrypt Error:", err.message, err.stack);
    throw err as Error;
  }
}
