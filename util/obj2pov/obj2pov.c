#include <stdio.h>
#include <stddef.h>
#include <string.h>

struct vector {
	float x, y, z;
}

vertices[1048576],
normals[1048576];

struct face {
	int vertex1, vertex2, vertex3;
	int normal1, normal2, normal3;
}

faces[1048576];

size_t vertex_i;
size_t normal_i;
size_t face_i;

void fix(char *line);
void parse(char *line);
void parse_v(void);
void parse_vn(void);
void parse_f(void);
void convert(void);

int main(void) {
	char line[256];
	while (fgets(line, sizeof(line), stdin)) {
		fix(line);
		parse(line);
	}
	convert();
	return 0;
}

void fix(char *line) {
	int c;
	size_t len = strlen(line);
	if (line[len - 1] == '\n')
		line[len - 1] = '\0';
	else
		while ((c = getchar()) != EOF && c != '\n');
}

void parse(char *line) {
	char *token, *start = line;
	while ((token = strtok(start, " "))) {
		start = NULL;
		if (!strcmp(token, "v"))
			parse_v();
		else if (!strcmp(token, "vn"))
			parse_vn();
		else if (!strcmp(token, "f"))
			parse_f();
	}
}

void parse_v(void) {
	int i = 0;
	char *token;
	struct vector result = { 0.0, 0.0, 0.0 };
	while ((token = strtok(NULL, " ")) && i++ < 4) {
		float value;
		sscanf(token, "%f", &value);
		switch (i) {
		case 1:
			result.x = value;
			break;
		case 2:
			result.y = value;
			break;
		case 3:
			result.z = value;
			break;
		case 4:
			result.x /= value;
			result.y /= value;
			result.z /= value;
			break;
		}
	}
	vertices[vertex_i++] = result;
}

void parse_vn(void) {
	int i = 0;
	char *token;
	struct vector result = { 0.0, 0.0, 0.0 };
	while ((token = strtok(NULL, " ")) && i++ < 3) {
		float value;
		sscanf(token, "%f", &value);
		switch (i) {
		case 1:
			result.x = value;
			break;
		case 2:
			result.y = value;
			break;
		case 3:
			result.z = value;
			break;
		}
	}
	normals[normal_i++] = result;
}

void parse_f(void) {
	int i = 0;
	char *token;
	struct face result = { 0, 0, 0, 0, 0, 0 };
	while ((token = strtok(NULL, " /")) && i++ < 8) {
		int value;
		sscanf(token, "%d", &value);
		switch (i) {
		case 1:
			result.vertex1 = value - 1;
			break;
		case 2:
			result.normal1 = value - 1;
			break;
		case 3:
			result.vertex2 = value - 1;
			break;
		case 4:
			result.normal2 = value - 1;
			break;
		case 5:
			result.vertex3 = value - 1;
			break;
		case 6:
			result.normal3 = value - 1;
			faces[face_i++] = result;
			break;
		case 7:
			result.vertex2 = result.vertex3;
			result.normal2 = result.normal3;
			result.vertex3 = value - 1;
			break;
		case 8:
			result.normal3 = value - 1;
			faces[face_i++] = result;
			break;
		}
	}
}

void convert(void) {
	size_t i;
	puts("#declare IMPORTED_MESH = mesh2 {");
	puts("	vertex_vectors {");
	printf("		%zu,\n", vertex_i);
	for (i = 0; i < vertex_i; i++)
		printf(
			"		<%f, %f, %f>%s",
			vertices[i].x,
			vertices[i].y,
			vertices[i].z,
			(i == vertex_i - 1) ? "\n" : ",\n"
		);
	puts("	}");
	puts("	normal_vectors {");
	printf("		%zu,\n", normal_i);
	for (i = 0; i < normal_i; i++)
		printf(
			"		<%f, %f, %f>%s",
			normals[i].x,
			normals[i].y,
			normals[i].z,
			(i == normal_i - 1) ? "\n" : ",\n"
		);
	puts("	}");
	puts("	face_indices {");
	printf("		%zu,\n", face_i);
	for (i = 0; i < face_i; i++)
		printf(
			"		<%d, %d, %d>%s",
			faces[i].vertex1,
			faces[i].vertex2,
			faces[i].vertex3,
			(i == face_i - 1) ? "\n" : ",\n"
		);
	puts("	}");
	puts("	normal_indices {");
	printf("		%zu,\n", face_i);
	for (i = 0; i < face_i; i++)
		printf(
			"		<%d, %d, %d>%s",
			faces[i].normal1,
			faces[i].normal2,
			faces[i].normal3,
			(i == face_i - 1) ? "\n" : ",\n"
		);
	puts("	}");
	puts("}");
}
