#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <openssl/sha.h>
#include <openssl/evp.h>
#include <pthread.h>

#define NUM_THREADS 7
#define NONCE_LENGTH 10

typedef struct {
    int thread_id;
    const char *data;
} thread_data_t;

void generate_random_nonce(char *buffer, size_t length) {
    const char charset[] = "0123456789abcdefghijklmopqrstuvwxyz";
    size_t charset_size = sizeof(charset) - 1;

    for (size_t i = 0; i < length; i++) {
        int random_index = rand() % charset_size;
        buffer[i] = charset[random_index];
    }
    buffer[length] = '\0';
}

void sha1_hash(const char *str, unsigned char *output) {
    EVP_MD_CTX *mdctx;
    const EVP_MD *md = EVP_sha1();
    unsigned int md_len;

    mdctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(mdctx, md, NULL);
    EVP_DigestUpdate(mdctx, str, strlen(str));
    EVP_DigestFinal_ex(mdctx, output, &md_len);
    EVP_MD_CTX_free(mdctx);
}

void print_hash(unsigned char *hash, size_t length) {
    for (size_t i = 0; i < length; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n");
}

int has_seven_consecutive_zeros(const unsigned char *hash) {
    char hash_str[SHA_DIGEST_LENGTH * 2 + 1];
    for (int i = 0; i < SHA_DIGEST_LENGTH; i++) {
        sprintf(&hash_str[i * 2], "%02x", hash[i]);
    }
    return strstr(hash_str, "0000000") != NULL;
}

void *hash_search(void *threadarg) {
    thread_data_t *data = (thread_data_t *) threadarg;
    unsigned char hash[SHA_DIGEST_LENGTH];
    char input_with_nonce[256];
    char nonce[NONCE_LENGTH + 1];

    while (1) {
        srand(time(NULL) + data->thread_id + rand());
        generate_random_nonce(nonce, NONCE_LENGTH);
        snprintf(input_with_nonce, sizeof(input_with_nonce), "%s%s", data->data, nonce);
        sha1_hash(input_with_nonce, hash);
        if (has_seven_consecutive_zeros(hash)) {
            printf("\aThread %d found a hash with seven consecutive zeros:\n", data->thread_id);
            print_hash(hash, SHA_DIGEST_LENGTH);
            printf("Nonce: %s\n", nonce);
//            pthread_exit(NULL);
        }
    }
}

int main(int argc, char *argv[]) {
    pthread_t threads[NUM_THREADS];
    thread_data_t thread_data[NUM_THREADS];
    const char *input_data = "ab1d40b436 gives 55 0xfcoins toff651a8c18";
    int rc;

    for (int t = 0; t < NUM_THREADS; t++) {
        thread_data[t].thread_id = t;
        thread_data[t].data = input_data;
        rc = pthread_create(&threads[t], NULL, hash_search, (void *)&thread_data[t]);
        if (rc) {
            printf("ERROR: return code from pthread_create() is %d\n", rc);
            exit(-1);
        }
    }

    for (int t = 0; t < NUM_THREADS; t++) {
        pthread_join(threads[t], NULL);
    }

    return 0;
}

