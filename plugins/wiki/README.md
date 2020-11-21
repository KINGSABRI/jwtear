# JWTear Wiki

## JWT
JSON Web Token (JWT) defines a container to transport data between interested parties. It became an IETF standard in May 2015 with the RFC 7519. There are multiple applications of JWT. The OpenID Connect is one of them. In OpenID Connect the id_token is represented as a JWT. Both in securing APIs and Microservices, the JWT is used as a way to propagate and verify end-user identity.

A JWT can be used to:
- Propagate one’s identity between interested parties.
- Propagate user entitlements between interested parties.
- Transfer data securely between interested parties over a unsecured channel.
- Assert one’s identity, given that the recipient of the JWT trusts the asserting party.

Following is a sample JWT, which is returned back from the Google OpenID Connect provider. Here the Google, which is the identity provider, asserts the identity of an end-user and passes the JWT to a service provider (a web or native mobile application).

```
eyJhbGciOiJSUzI1NiIsImtpZCI6Ijc4YjRjZjIzNjU2ZGMzOTUzNjRmMWI2YzAyOTA3NjkxZjJjZGZmZTEifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTEwNTAyMjUxMTU4OTIwMTQ3NzMyIiwiYXpwIjoiODI1MjQ5ODM1NjU5LXRlOHFnbDcwMWtnb25ub21ucDRzcXY3ZXJodTEyMTFzLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiZW1haWwiOiJwcmFiYXRoQHdzbzIuY29tIiwiYXRfaGFzaCI6InpmODZ2TnVsc0xCOGdGYXFSd2R6WWciLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXVkIjoiODI1MjQ5ODM1NjU5LXRlOHFnbDcwMWtnb25ub21ucDRzcXY3ZXJodTEyMTFzLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiaGQiOiJ3c28yLmNvbSIsImlhdCI6MTQwMTkwODI3MSwiZXhwIjoxNDAxOTEyMTcxfQ.TVKv-pdyvk2gW8sGsCbsnkqsrS0T-H00xnY6ETkIfgIxfotvFn5IwKm3xyBMpy0FFe0Rb5Ht8AEJV6PdWyxz8rMgX2HROWqSo_RfEfUpBb4iOsq4W28KftW5H0IA44VmNZ6zU4YTqPSt4TPhyFC9fP2D_Hg7JQozpQRUfbWTJI
```
This looks gibberish till you break it by periods (.) and base64url-decode each part. There are two periods in it, which break the whole string into three parts. Once you base64url-decode the fist part, it appears like below:

```json
{"alg":"RS256","kid":"78b4cf23656dc395364f1b6c02907691f2cdffe1"}
```

## JOSE Header
This first part(once parted by the periods) of the JWT is known as the JOSE header . JOSE stands for Javascript Object Signing and Encryption — and it’s the name of the IETF working group, which works on standardizing the representation of integrity-protected data using JSON data structures. The above JOSE header indicates that it’s a signed message. Google asserts the identity of the end-user by signing the JWT, which carries data related to the user’s identity.

> A signed JWT is known as a JWS (JSON Web Signature). In fact a JWT does not exist itself — either it has to be a JWS or a JWE (JSON Web Encryption). Its like an abstract class — the JWS and JWE are the concrete implementations.

```
      JWT
       |
 .----` `---.
 |          |
JWS        JWE
```

Going back to the JOSE header returned back from Google, both the **alg** and **kid** elements there, are not defined in the JWT specification, but in the JSON Web Signature (JWS) specification. The JWT specification only defines two elements (typ and cty) in the JOSE header and both the JWS and JWE specifications extend it to add more appropriate elements.

**typ (type):** 
The *typ* element is used to define the media type of the complete JWT. A media type is an identifier, which defines the format of the content, transmitted on the Internet. There are two types of components that process a JWT: JWT implementations and JWT applications. Nimbus is a JWT implementation in Java. The Nimbus library knows how to build and parse a JWT. A JWT application can be anything, which uses JWTs internally. A JWT application uses a JWT implementation to build or parse a JWT. In this case, the typ element is just another element for the JWT implementation. It will not try to interpret the value of it, but the JWT application would. The typ element helps JWT applications to differentiate the content of the JWT when the values that are not JWTs could also be present in an application data structure along with a JWT object. This is an optional element and if present for a JWT, it is recommended to use JWT as the media type.


**cty (content type):** 
The *cty* element is used to define the structural information about the JWT. It is only recommended to use this element in the case of a nested JWT.

The JWS specification is not bound to any specific algorithm. All applicable algorithms for signing are defined under the JSON Web Algorithms (JWA) specification, which is the RFC 7518. The section 3.1 of RFC 7518 defines all possible **alg** element values for a JWS token. The value of the kid element provides an indication or a hint about the key, which is used to sign the message. Looking at the kid, the recipient of the message should know where and how to lookup for the key and find it.

> In a JWT, the members of the JSON object represented by the JOSE header describe the cryptographic operations applied to the JWT and optionally, additional properties of the JWT. Depending upon whether the JWT is a JWS or JWE, the corresponding rules for the JOSE header values apply. Both under the JWS and JWE, the JOSE header is a must — or in other words there exists no JWT without a JOSE header.

### Claim Set
Focus back on the sample JWT returned back from Google. More precisely now we know its a JWS. Following shows the base64url-decoded claim set returned back from Google. The second part of the JWT (when parted by the period (.)) is known as the JWT claim set. White-spaces can be explicitly retained while building the JWT claim set — no canonicalization is required before base64url-encoding or decoding. Canonicalization is the process of converting different forms of a message into a single standard form. This is used mostly before signing XML messages.
```json
{
    "iss":"accounts.google.com",
    "sub":"115.654832477893315823",
    "azp":"26655622859-np4sqv7erh12311s.apps.googleusercontent.com",
    "email":"prabath@wso2.com",
    "at_hash":"zf86vNulsLB*gFaqRwdzYg",
    "email_verified":true,
    "aud":"26655622859-np4sqv7erh12311s.apps.googleusercontent.com",
    "hd":"wso2.com",
    "iat":1401908271,
    "exp":1401908271
}
```

The JWT claim set represents a JSON object whose members are the claims asserted by the JWT issuer. Each claim name within a JWT must be unique. If there are duplicate claim names, then the JWT parser could either return a parsing error or just return back the claims set with the very last duplicate claim. JWT specification does not explicitly define what claims are mandatory and what are optional. It’s up to the each application of JWT to define mandatory and optional claims. For example, the OpenID Connect specification defines the mandatory and optional claims. According to the OpenID Connect core specification, iss, sub, aud, exp and iat are treated as mandatory elements, while auth_time, nonce, acr, amr and azp are optional elements. In addition to the mandatory and optional claims, which are defined in the specification, the identity provider can include additional elements into the JWT claim set.

### Signature

Once again, focus back on the sample JWT returned back from Google. The third part of the JWT (when parted by the period (.)), is the signature, which is also base64url-encoded. The cryptographic elements related to the signature are defined in the JOSE header. In this particular example, Google uses RSASSA-PKCS1-V1_5 with the SHA-256 hashing algorithm, which is expressed by the value of the alg element in the JOSE header: RS256.


### Serialization

A signed or an encrypted message can be serialized in two ways by following the JWS or JWE specification: the JWS/JWE compact serialization and the JWS/JWE JSON serialization. The Google OpenID Connect response discussed before uses the JWS compact serialization. In fact, the OpenID Connect specification mandates to use JWS compact serialization and JWE compact serialization whenever necessary.

Now we can further refine our definition of the JWT. So far we know that both the JWS and JWE tokens are instances of the JWT. But that is not 100% precise. We call a JWS or JWE, a JWT only if it follows the compact serialization. Any JWT must follow compact serialization. In other words a JWS or JWE token, which follows JSON serialization cannot be called as a JWT.

## JWS Compact Serialization

JWS compact serialization represents a signed JWT as a compact URL-safe string. This compact string has three main elements separated by periods (.): the JOSE header, the JWS payload and the JWS signature. If you use compact serialization against a JSON payload (or any payload — even XML), then you can have only a single signature, which is computed over the complete JOSE header and JWS payload.

```
BASE64URL(UTF8(JWS Header)) + '.' +
BASE64URL(JWS Payload)      + '.' +
BASE64URL(JWS Signature)
```

### JWS Compact Serialization — Signing Process

Following lists out the signing process of a JWS under the compact serialization.

* Build a JSON object including all the header elements, which express the cryptographic properties of the JWS token — this is known as the JOSE header. As discussed before, the token issuer should advertise in the JOSE header, the public key corresponding to the key used to sign the message. This can be expressed via any of these header elements: jku, jwk, kid, x5u, x5c, x5t and x5t#s256.
* Compute the base64url-encoded value against the UTF-8 encoded JOSE header from the 1st step, to produce the 1st element of the JWS token.
* Construct the payload or the content to be signed — this is known as the JWS payload. The payload is not necessarily JSON — it can be any content. Yes, you read it correctly, the payload of a JWS necessarily need not to be JSON - if you’d like it can be XML too.
* Compute the base64url-encoded value of the JWS payload from the previous step to produce the 2nd element of the JWS token.
* Build the message to compute the digital signature or the Mac. The message is constructed as ASCII(BASE64URL-ENCODE(UTF8(JOSE Header)) ‘.’ BASE64URL-ENCODE(JWS Payload)).
* Compute the signature over the message constructed in the previous step, following the signature algorithm defined by the JOSE header element alg. The message is signed using the private key corresponding to the public key advertised in the JOSE header.
* Compute the base64url encoded value of the JWS signature produced in the previous step, which is the 3rd element of the serialized JWS token.
* Now we have all the elements to build the JWS token in the following manner. The line breaks are introduced only for clarity.



## JWE Compact Serialization

With the JWE compact serialization, a JWE token is built with five key components, each separated by a period (.): JOSE header, JWE Encrypted Key, JWE initialization vector, JWE Additional Authentication Data (AAD), JWE Ciphertext and JWE Authentication Tag.

```
BASE64URL(UTF8(JWE Protected Header)) + '.' +
BASE64URL(JWE Encrypted Key)          + '.' +
BASE64URL(JWE Initialization Vector)  + '.' +
BASE64URL(JWE Ciphertext)             + '.' +
BASE64URL(JWE Authentication Tag)
```

The JOSE header is the very first element of the JWE token produced under compact serialization. The structure of the JOSE header is the same, as we discussed under JWS other than couple of exceptions. The JWE specification introduces two new elements (enc and zip), which are included in the JOSE header of the JWE token, in addition to what’s defined by the JSON Web Signature (JWS) specification.

To understand JWE Encrypted Key section of the JWE, we first need to understand how a JSON payload gets encrypted. The enc element of the JOSE header defines the content encryption algorithm and it should be a symmetric Authenticated Encryption with Associated Data (AEAD) algorithm. The alg element of the JOSE header defines the encryption algorithm to encrypt the Content Encryption Key (CEK). This algorithm can also be defined as the key wrapping algorithm, as it wraps the CEK.

*Authenticated Encryption with Associated Data (AEAD) is a block cipher mode of operation which simultaneously provides confidentiality, integrity, and authenticity assurances on the data; decryption is combined in single step with integrity verification.*

Let’s look at the following JOSE header. For content encryption, it uses A256GCM algorithm; and for key wrapping, RSA-OAEP:

```json
{"alg":"RSA-OAEP","enc":"A256GCM"}
```

A256GCM is defined in the JWA specification. It uses the Advanced Encryption Standard (AES) in Galois/Counter Mode (GCM) algorithm with a 256-bit long key, and it’s a symmetric key algorithm used for AEAD. Symmetric keys are mostly used for content encryption and it is much faster than asymmetric-key encryption. At the same time, asymmetric-key encryption can’t be used to encrypt large messages.

RSA-OAEP is too defined in the JWA specification. During the encryption process, the token issuer generates a random key, which is 256 bits in size and encrypts the message using that key following the AES GCM algorithm. Next, the key used to encrypt the message is encrypted using RSA-OAEP, which is an asymmetric encryption scheme. The RSA-OAEP encryption scheme uses RSA algorithm with the Optimal Asymmetric Encryption Padding (OAEP) method. Finally the encrypted symmetric key is placed in the JWE Encrypted Header section of the JWE.

Some encryption algorithms, which are used for content encryption require an initialization vector, during the encryption process. Initialization vector is a randomly generated number, which is used along with a secret key to encrypt data. This will add randomness to the encrypted data, which will prevent repetition even the same data gets encrypted using the same secret key again and again. To decrypt the message at the token recipient end, it has to know the initialization vector, hence it is included in the JWE token, under the JWE Initialization Vector element. If the content encryption algorithm does not require an initialization vector, then the value of this element should be kept empty.

The fourth element of the JWE token is the base64url-encoded value of the JWE ciphertext. The JWE ciphertext is computed by encrypting the plaintext JSON payload using the Content Encryption Key (CEK), the JWE initialization vector and the Additional Authentication Data (AAD) value, with the encryption algorithm defined by the header element enc. The algorithm defined by the enc header element should be a symmetric Authenticated Encryption with Associated Data (AEAD) algorithm. The AEAD algorithm, which is used to encrypt the plaintext payload, also allows specifying Additional Authenticated Data (AAD).

The base64url-encoded value of the JWE Authenticated Tag is the final element of the JWE token. As discussed before the value of the authentication tag is produced during the AEAD encryption process, along with the ciphertext. The authentication tag ensures the integrity of the ciphertext and the Additional Authenticated Data (AAD).

### JWE Compact Serialization — Signing Process

Following lists out the encryption process of a JWE under the compact serialization.

* Figure out the key management mode by the algorithm used to determine the Content Encryption Key (CEK) value. This algorithm is defined by the alg element in the JOSE header. There is only one alg element per JWE token.
* Compute the CEK and calculate the JWE Encrypted Key based on the key management mode, picked in the previous. The CEK is later used to encrypt the JSON payload. There is only one JWE Encrypted Key element in the JWE token.
* Compute the base64url-encoded value of the JWE Encrypted Key, which is produced in the previous step. This is the 2nd element of the JWE token.
* Generate a random value for the JWE Initialization Vector. Irrespective of the serialization technique, the JWE token will carry the value of the base64url-encoded value of the JWE Initialization Vector. This is the 3rd element of the JWT token.
* If token compression is needed, the JSON payload in plaintext must be compressed following the compression algorithm defined under the zip header element.
* Construct the JSON representation of the JOSE header and find the base64url-encoded value of the JOSE header with UTF8 encoding. This is the 1st element of the JWE token.
* To encrypt the JSON payload, we need the CEK (which we already have), the JWE Initialization Vector (which we already have), and the Additional Authenticated Data (AAD). Compute ASCII value of the encoded JOSE header from the previous step and use it as the AAD.
* Encrypt the compressed JSON payload (from the previous step) using the CEK, the JWE Initialization Vector and the Additional Authenticated Data (AAD), following the content encryption algorithm defined by the header enc header element.
* The algorithm defined by the enc header element is a AEAD algorithm and after the encryption process, it produce the ciphertext and the Authentication Tag.
* Compute the base64url-encoded value of the ciphertext, which is produced by the step one before the previous. This is the 4th element of the JWE token.
* Compute the base64url-encoded value of the Authentication Tag, which is produced by the step one before the previous. This is the 5th element of the JWE token.
* Now we have all the elements to build the JWE token in the following manner. The line breaks are introduced only for clarity.

### JWE Initialization Vector

This carries the same meaning as explained under JWE compact serialization, previously. The iv element in the JWE token represents the value of the initialization vector used for encryption.

### JWE Ciphertext

This carries the same meaning as explained under JWE compact serialization, previously. The ciphertext element in the JWE token carries the base64url-encoded value of the JWE ciphertext

### JWE Authentication Tag

This carries the same meaning as explained under JWE compact serialization, previously. The tag element in the JWE token carries the base64url-encoded value of the JWE authenticated tag, which is an outcome of the encryption process using an AEAD algorithm.

_source(JWT, JWS and JWE for Not So Dummies! (Part I))_

---


## Attacks

### JWS

* Change the algorithm from HS256 to none.
* Change the algorithm from RS256 to HS256, and use the public key as the secret key for the HMAC.
* Crack\Bruteforce the HMAC signature key. Then create a new token with the discovered password
* Change the user to admin and keep the header and signature as is.


### JWE

* Decode the token, change the payload, then use the target's public key (e.g. public.key, pub.key) to encrypt them.


## Vulnerable Applications

* [Damn Vulnerable Web Services - DVWS](https://github.com/snoopysecurity/dvws)
* [Pentesterlab(Free) - JSON Web Token I](https://pentesterlab.com/exercises/jwt/)
* [Pentesterlab(PRO)  - JSON Web Token II](https://pentesterlab.com/exercises/jwt_ii/)
* [Pentesterlab(PRO)  - JWT III](https://pentesterlab.com/exercises/jwt_iii/)
* [Pentesterlab(PRO)  - JWT IV](https://pentesterlab.com/exercises/jwt_iv)
* [Pentesterlab(PRO)  - JWT V](https://pentesterlab.com/exercises/jwt_v)
* [Pentesterlab(PRO)  - JWT VI](https://pentesterlab.com/exercises/jwt_vi)
* [Pentesterlab(PRO)  - JWT VII](https://pentesterlab.com/exercises/jwt_vii)
* [Pentesterlab(PRO)  - JWT VIII](https://pentesterlab.com/exercises/jwt_viii)
* [Pentesterlab(PRO)  - JWT X](https://pentesterlab.com/exercises/jwt_x/)
* [Pentesterlab(PRO)  - JWT XI](https://pentesterlab.com/exercises/jwt_xi)
* [Pentesterlab(PRO)  - JWT XII](https://pentesterlab.com/exercises/jwt_xii)
* [Pentesterlab(PRO)  - JSON Web Encryption](https://pentesterlab.com/exercises/jwe)
* [Vulnerable JWT implementations](https://github.com/Sjord/jwtdemo)

## Resources
* [JWT, JWS and JWE for Not So Dummies! (Part I)](https://medium.facilelogin.com/jwt-jws-and-jwe-for-not-so-dummies-b63310d201a3)
* [OpenID - JWT, JWS, JWE, JWK, and JWA Implementations](https://openid.net/developers/jwt/)
* [List of JWT libraries](https://jwt.io/#libraries-io)
* [Attacking JWT authentication](https://www.sjoerdlangkemper.nl/2016/09/28/attacking-jwt-authentication/)
* [JWT: Signature-vs-MAC attacks](https://snikt.net/blog/2019/05/16/jwt-signature-vs-mac-attacks/)
* [JWT Attack Walk-Through](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2019/january/jwt-attack-walk-through/)
* [Hack the JWT Token](https://habr.com/en/post/450054/)
* [Damn Vulnerable Service](https://github.com/snoopysecurity/dvws)
* [CSRF JWT redirect leak](https://gist.github.com/stefanocoding/8cdc8acf5253725992432dedb1c9c781)
* [Critical vulnerabilities in JSON Web Token libraries](https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/)
* [JWT Attack Playbook](https://github.com/ticarpi/jwt_tool/wiki)
