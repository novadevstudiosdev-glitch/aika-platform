-- CreateEnum
CREATE TYPE "ProjectStatus" AS ENUM ('ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "TransportMode" AS ENUM ('ROAD', 'RIVER', 'RAIL', 'MARITIME');

-- CreateEnum
CREATE TYPE "ProjectPhase" AS ENUM ('PRE_FEASIBILITY', 'FEASIBILITY', 'DESIGN', 'CONSTRUCTION', 'OPERATION');

-- CreateEnum
CREATE TYPE "PermitStatus" AS ENUM ('IN_PROGRESS', 'GRANTED', 'RENEWED', 'REJECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "MinorChangeStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'IN_PROGRESS');

-- CreateEnum
CREATE TYPE "EvaluationStatus" AS ENUM ('DRAFT', 'COMPLETED');

-- CreateEnum
CREATE TYPE "ComplianceLevel" AS ENUM ('BASIC', 'GOOD', 'VERY_GOOD', 'EXCELLENT', 'EXCEPTIONAL');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "image" TEXT,
    "password" TEXT,
    "emailVerified" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Project" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "description" TEXT,
    "transportMode" "TransportMode" NOT NULL,
    "phase" "ProjectPhase" NOT NULL,
    "status" "ProjectStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Permit" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "authority" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "resolution" TEXT,
    "issueDate" TIMESTAMP(3),
    "expiryDate" TIMESTAMP(3),
    "status" "PermitStatus" NOT NULL DEFAULT 'IN_PROGRESS',
    "requirements" TEXT,
    "notes" TEXT,
    "alertSent30" BOOLEAN NOT NULL DEFAULT false,
    "alertSent7" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Permit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MinorChange" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "requestDate" TIMESTAMP(3) NOT NULL,
    "status" "MinorChangeStatus" NOT NULL DEFAULT 'PENDING',
    "authorityRef" TEXT,
    "resolvedDate" TIMESTAMP(3),
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MinorChange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AikaEvaluation" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "phase" "ProjectPhase" NOT NULL,
    "status" "EvaluationStatus" NOT NULL DEFAULT 'DRAFT',
    "finalScore" DOUBLE PRECISION,
    "sustainabilityGrade" INTEGER,
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AikaEvaluation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CriterionResponse" (
    "id" TEXT NOT NULL,
    "evaluationId" TEXT NOT NULL,
    "criterionCode" TEXT NOT NULL,
    "dimension" TEXT NOT NULL,
    "component" TEXT NOT NULL,
    "criterionName" TEXT NOT NULL,
    "complianceLevel" "ComplianceLevel",
    "scoreObtained" DOUBLE PRECISION,
    "scoreMax" DOUBLE PRECISION,
    "justification" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CriterionResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Document" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "permitId" TEXT,
    "minorChangeId" TEXT,

    CONSTRAINT "Document_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "Account_userId_idx" ON "Account"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE INDEX "Session_userId_idx" ON "Session"("userId");

-- CreateIndex
CREATE INDEX "Project_userId_idx" ON "Project"("userId");

-- CreateIndex
CREATE INDEX "Project_status_idx" ON "Project"("status");

-- CreateIndex
CREATE INDEX "Permit_projectId_idx" ON "Permit"("projectId");

-- CreateIndex
CREATE INDEX "Permit_status_idx" ON "Permit"("status");

-- CreateIndex
CREATE INDEX "Permit_expiryDate_idx" ON "Permit"("expiryDate");

-- CreateIndex
CREATE INDEX "MinorChange_projectId_idx" ON "MinorChange"("projectId");

-- CreateIndex
CREATE INDEX "MinorChange_status_idx" ON "MinorChange"("status");

-- CreateIndex
CREATE UNIQUE INDEX "AikaEvaluation_projectId_key" ON "AikaEvaluation"("projectId");

-- CreateIndex
CREATE INDEX "CriterionResponse_evaluationId_idx" ON "CriterionResponse"("evaluationId");

-- CreateIndex
CREATE INDEX "CriterionResponse_criterionCode_idx" ON "CriterionResponse"("criterionCode");

-- CreateIndex
CREATE INDEX "Document_permitId_idx" ON "Document"("permitId");

-- CreateIndex
CREATE INDEX "Document_minorChangeId_idx" ON "Document"("minorChangeId");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Permit" ADD CONSTRAINT "Permit_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MinorChange" ADD CONSTRAINT "MinorChange_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AikaEvaluation" ADD CONSTRAINT "AikaEvaluation_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CriterionResponse" ADD CONSTRAINT "CriterionResponse_evaluationId_fkey" FOREIGN KEY ("evaluationId") REFERENCES "AikaEvaluation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_permitId_fkey" FOREIGN KEY ("permitId") REFERENCES "Permit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_minorChangeId_fkey" FOREIGN KEY ("minorChangeId") REFERENCES "MinorChange"("id") ON DELETE CASCADE ON UPDATE CASCADE;
