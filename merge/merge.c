/**
 * name: merge.c
 * author: Loulanguju
 * time: 2013-8-26
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define NAME_SIZE 512
#define BUFFER_SIZE 1024

typedef struct MergeItem_t {
  char input[NAME_SIZE];
  int ioffset;
  char output[NAME_SIZE];
  int offset;
  int count;
} MergeItem, *pMergeItem;

int config_analysis(char *str, MergeItem *merge) {
  int i = 0;
  int tempi;
  int input = 0, ioffset = 0, output = 0, offset = 0, count = 0;
  char *p, buffer[BUFFER_SIZE];
  
  if (str == NULL || strlen(str) == 0) {
    return 0;
  }

  if (merge == NULL) {
    return 0;
  }

  for (p = str, i = 0; *p != '\0'; p++) {
    switch(*p) {
    case '#':
      return 0;
    case ' ':
      break;
    case ',':
      buffer[i] = '\0';
      if (input == 0) {
        strcpy(merge->input, buffer);
        input = 1;
      } else if (ioffset == 0) {
        sscanf(buffer, "%d", &tempi);
        merge->ioffset = tempi;
        ioffset = 1;
      } else if (output == 0) {
        strcpy(merge->output, buffer);
        output = 1;
      } else if (offset == 0) {
        sscanf(buffer, "%d", &tempi);
        merge->offset = tempi;
        offset = 1;
      }
      i = 0;
      break;
    case '\n':
      if (offset == 0)
        return 0;

      if (count == 0) {
        sscanf(buffer, "%d", &tempi);
        merge->count = tempi;
        count = 1;
      } else
        return 0;
      break;
    default:
      buffer[i++] = *p; 
    }
  } /* End the While */

  if (count == 0) {
    merge->count  = 1;
  }

  if (input == 0 || ioffset == 0 || output == 0 || offset == 0 || count == 0) {
    return 0;
  }

  return 1;
}

int main(int argc, char *argv) {
  FILE *file = NULL;
  int input = -1, output = -1;
  char default_name[NAME_SIZE] = "default.conf";
  char buffer[BUFFER_SIZE];
  char copy_buffer[BUFFER_SIZE / 2];
  pMergeItem merge = NULL;
  int size = 0, n = 0;
  int i = 0;
  
  printf("===============================================\n");
  printf("\t\t   Merge\n");
  printf("\t  Merge the image files into a file\n");
  printf("\t  CopyRight (c) Loulanguju\n");
  printf("\t  All rights reserved\n");
  printf("===============================================\n");

  if ((file = fopen(default_name, "r")) == NULL) {
    printf("ERROR: No Such File %s!\n", default_name);
    return 1;
  }

  while (fgets(buffer, BUFFER_SIZE, file)) {
    if (merge == NULL) {
      merge = (struct MergeItem_t *)malloc(sizeof (struct MergeItem_t));
    }
    if (config_analysis(buffer, merge)) {
      input = open(merge->input, O_RDONLY);
      if (input == -1) {
        printf("ERROR: No sunch file %s\n", merge->input);
        continue ;
      }

      output = open(merge->output, O_WRONLY);
      if (output == -1) {
        printf("ERROR: Can't Create the output file %s!\n", merge->output);
        continue ;
      }

      /**
       * Move the file pointer
       */
      lseek(input, merge->ioffset * 512, SEEK_SET);
      lseek(output, merge->offset * 512, SEEK_SET);

      /**
       * Copy data from input file to output file
       */
      size = 0;
      for (i = 0; i < merge->count; i++) {
        memset(copy_buffer, 0, sizeof(copy_buffer));
        if ((n = read(input, copy_buffer, 512)) > 0)  {
          size += n;
          write(output, copy_buffer, BUFFER_SIZE / 2);
        }
      }

      printf("SUCCESS: Module %s -- > %s Cpoy success Data size: %d\n", merge->input, merge->output, size);

      close(input);
      close(output);
    } else {
      continue ;
    }
  }

  printf("Copy Over!\n");

  free(merge);
  fclose(file);//close the configuration file
  return 0;
}
